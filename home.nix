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

    # CLI Tools
    # TODO: Check if there is options way for each
    bat
    btop
    eza
    fd
    fzf
    delta
    lazygit
    neovim
    ripgrep
    yazi
  ];

  # Nix knows exactly what's installed, so these are set unconditionally
  # instead of guarding with `command -q` at fish runtime.
  home.sessionVariables = {
    TERM = "xterm-256color";

    EDITOR = "nvim";
    VISUAL = "nvim";
    GIT_EDITOR = "nvim";

    MANROFFOPT = "-c"; # prevent raw escape codes in man pages piped through bat
    BAT_PAGER = "less";
    MANPAGER = "sh -c 'col -bx | bat --style=plain --language=man'";
    PAGER = "bat --paging=always --style=plain";
  };

  # Extra PATH entries (replaces the user-bin portion of the old fish
  # PATH bootstrap; the brew/`/usr/local` portions have no Nix equivalent
  # needed, so they're dropped).
  home.sessionPath = [
    "$HOME/.local/sbin"
    "$HOME/.local/bin"
    "$HOME/sbin"
    "$HOME/bin"
  ];

  # Symlinked out of the store (not copied) so editing the file in the repo
  # takes effect immediately -- no rebuild/switch needed to pick up changes.
  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workplace/MyNIXOS/hypr/hyprland.lua";

  programs.zsh = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # `zoxide init fish`; cd/cdi aliases above wire it in.
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;

    globalConfig = {
      tools = {
        python = "3.14";
        node = "lts";
      };

      # Prefer precompiled builds over compiling from source -- NixOS has no
      # C toolchain on PATH by default. Needs programs.nix-ld.enable (in
      # configuration.nix) so the precompiled binaries can actually run.
      settings = {
        python.compile = false;
        node.compile = false;
      };
    };
  };

  programs.home-manager.enable = true;
}
