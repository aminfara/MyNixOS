#!/usr/bin/env bash
# Bootstrap: generate config-override/ for this machine, then rebuild.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERRIDE_DIR="$SCRIPT_DIR/config-override"

if [[ -d "$OVERRIDE_DIR" ]]; then
  echo "config-override/ already exists. Remove it first to re-bootstrap."
  exit 1
fi

echo "=== MyNixOS Bootstrap ==="
echo

prompt() {
  local -n _ref=$1
  local msg="$2" default="$3"
  read -rp "$msg [$default]: " _ref
  _ref="${_ref:-$default}"
}

# Detect architecture
case "$(uname -m)" in
  x86_64)  default_system="x86_64-linux"  ;;
  aarch64) default_system="aarch64-linux" ;;
  *)       default_system="$(uname -m)-linux" ;;
esac

# Default full name from GECOS field
default_fullname="$(getent passwd "$USER" 2>/dev/null | cut -d: -f5 | cut -d, -f1 || echo 'Your Name')"

prompt hostname  "Hostname"          "$(hostname -s)"
prompt username  "Username"          "$USER"
prompt fullname  "Full name"         "$default_fullname"
prompt email     "Email"             "user@example.com"
prompt timezone  "Timezone"          "UTC"
prompt locale    "Locale"            "en_US.UTF-8"
prompt kblayout  "Keyboard layout"   "us"
prompt kbvariant "Keyboard variant"  ""
prompt system    "Nix system"        "$default_system"

mkdir -p "$OVERRIDE_DIR"

# --- settings.nix ---
cat > "$OVERRIDE_DIR/settings.nix" <<EOF
{
  system   = "$system";
  hostname = "$hostname";
  username = "$username";
  fullname = "$fullname";
  email    = "$email";
  timeZone = "$timezone";
  locale   = "$locale";
  keyboardLayout        = "$kblayout";
  keyboardLayoutVariant = "$kbvariant";
}
EOF

# --- hardware-configuration.nix ---
echo
echo "Generating hardware configuration..."
nixos-generate-config --show-hardware-config > "$OVERRIDE_DIR/hardware-configuration.nix"

# --- extras.nix — bootloader depends on firmware ---
if [[ -d /sys/firmware/efi ]]; then
  # EFI: systemd-boot is already the default in common.nix
  cat > "$OVERRIDE_DIR/extras.nix" <<'EOF'
{ pkgs, settings, ... }:
{
  # EFI machine — systemd-boot enabled by default (common.nix).
  # Switch to GRUB if preferred:
  #   boot.loader.systemd-boot.enable = false;
  #   boot.loader.grub = { enable = true; device = "nodev"; efiSupport = true; };

  services.openssh.enable = true;
}
EOF
else
  # BIOS: GRUB on the primary disk
  disk="$(lsblk -dno NAME,TYPE | awk '$2=="disk"{print "/dev/"$1; exit}')"
  cat > "$OVERRIDE_DIR/extras.nix" <<EOF
{ pkgs, settings, ... }:
{
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "$disk";
  };

  services.openssh.enable = true;
}
EOF
fi

# --- git init inside config-override ---
git -C "$OVERRIDE_DIR" init -q
git -C "$OVERRIDE_DIR" add .
git -C "$OVERRIDE_DIR" commit -q -m "bootstrap: initial machine config"

# Reset flake.lock so nix picks up the new localConfig path
rm -f "$SCRIPT_DIR/flake.lock"

echo
echo "Done! Run:"
echo "  sudo nixos-rebuild switch --flake .#local"
