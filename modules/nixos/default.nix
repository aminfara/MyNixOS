# NixOS settings shared by every host.
{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    nixd
    nixfmt
    wget
  ];

  services.openssh.enable = true;

  # Registers fish in /etc/shells so `chsh -s $(which fish)` works; actual
  # config lives in modules/home-manager/fish.nix. Doesn't change anyone's
  # login shell on its own.
  programs.fish.enable = true;
}
