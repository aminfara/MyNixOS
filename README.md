# MyNixOS

Personal NixOS configuration. Shared modules live in this repo; per-machine
config (hardware, settings, bootloader) lives in `config-override/` — gitignored,
created once by `bootstrap.sh`.

## New machine

```bash
git clone <repo-url> ~/mynixos && cd ~/mynixos
sudo bash bootstrap.sh
sudo nixos-rebuild build --flake .#local --override-input localConfig path:./config-override
```

`bootstrap.sh` prompts for hostname, username, timezone, etc., detects your
hardware and firmware (EFI vs BIOS), and writes `config-override/` accordingly.

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#local --override-input localConfig path:./config-override
```

## Customisation

Edit `config-override/extras.nix` for anything machine-specific (bootloader,
extra packages, services):

IMPORTANT: If you are changing a setting that is already set by main configuration (e.g. `boot.loader`), you need to `lib.mkForce` it in `extras.nix` to override the main config.
