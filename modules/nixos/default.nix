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
}
