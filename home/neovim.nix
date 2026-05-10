# Neovim — managed by Home Manager.
#
# The LazyVim config lives in config/nvim/ and is symlinked into
# $XDG_CONFIG_CONFIG/nvim at activation time.

{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Symlink config/nvim/ → ~/.config/nvim
  # `recursive = true` creates individual symlinks per file so that
  # lazy-lock.json (written at runtime by LazyVim) is a real file, not a
  # symlink into the read-only Nix store.
  xdg.configFile."nvim" = {
    source = ../config/nvim;
    recursive = true;
  };
}
