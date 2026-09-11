{ config, pkgs, ... }:

{
  home.username = "ali";
  home.homeDirectory = "/home/ali";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    git
    nixfmt
    nixd
    claude-code
    ghostty
    stylua
    lua-language-server
  ];

  # Symlinked out of the store (not copied) so editing the file in the repo
  # takes effect immediately -- no rebuild/switch needed to pick up changes.
  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workplace/MyNIXOS/hypr/hyprland.lua";

  programs.home-manager.enable = true;
}
