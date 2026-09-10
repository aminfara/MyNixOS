{ pkgs, ... }:

{
  home.username = "ali";
  home.homeDirectory = "/home/ali";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    git
    nixfmt
    nixd
    claude-code
  ];

  programs.home-manager.enable = true;
}
