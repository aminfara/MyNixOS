# Shrubbery — Apple Silicon Mac (nix-darwin)
{ pkgs, ... }:
{
  imports = [
    ../../modules/shared/nix-settings.nix
    ../../modules/shared/locale.nix
    ../../modules/darwin/common.nix
  ];

  networking.hostName = "shrubbery";
  networking.computerName = "Shrubbery"; # shown in Finder / Sharing preferences

  # Add shrubbery-only system packages here (prefer home.packages for user tools)
  environment.systemPackages = with pkgs; [ ];

  # Set once at first install — do not change afterwards
  system.stateVersion = 5;
}
