{ pkgs, settings, ... }:

{
  home.username = settings.username;
  home.homeDirectory = "/home/${settings.username}";
  home.stateVersion = "25.11";

  programs.fish.enable = true;
}
