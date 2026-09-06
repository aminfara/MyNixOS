# Home-manager settings shared by every user.
{ config, lib, ... }:
{
  imports = [
    ./environment.nix
    ./tools.nix
    ./bat.nix
    ./eza.nix
    ./zoxide.nix
    ./starship.nix
    ./fish.nix
  ];

  home.stateVersion = "26.05";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
}
