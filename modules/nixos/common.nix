# NixOS system-level config shared across all Linux machines.
# Keep this deliberately minimal — user tools belong in home/packages.nix.
{ pkgs, ... }:
{
  networking.networkmanager.enable = true;

  # Keyboard layout for X11 / Wayland
  services.xserver.xkb = {
    layout = "us";
    variant = "mac";
  };

  # SSH agent at system level so every session (including graphical) inherits it
  programs.ssh.startAgent = true;

  # Neovim as the system fallback editor (home-manager will overlay this for the user)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Minimal system-wide packages — prefer home.packages for per-user tools
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
  ];
}
