{ config, pkgs, ... }:

{
  home.username = "ali";
  home.homeDirectory = "/home/ali";
  home.stateVersion = "25.11"; # Did you read the comment in configuration.nix?
  programs.git.enable = true;
  programs.fish.enable = true;
}
