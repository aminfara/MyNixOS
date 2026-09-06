# Home-manager settings shared by every user.
{ config, lib, ... }:
{
  home.stateVersion = "26.05";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";

  programs.bash = {
    enable = true;
    shellAliases = {
      gst = "git status";
    };
  };
}
