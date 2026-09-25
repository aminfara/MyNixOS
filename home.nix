{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.home-manager.enable = true;

  home = {
    username = "ali";
    homeDirectory = "/home/ali";
    stateVersion = "26.05";

    packages = with pkgs; [
      git
      nixfmt
      nixd
      claude-code
      ghostty
      stylua
      lua-language-server

      # CLI Tools
      # TODO: Check if there is options way for each
      btop
      fd
      fzf
      delta
      lazygit
      neovim
      ripgrep
      yazi
    ];

    sessionVariables = {
      TERM = "xterm-256color";
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
      MANROFFOPT = "-c"; # prevent raw escape codes in man pages piped through bat
      BAT_PAGER = "less";
      MANPAGER = "sh -c 'col -bx | bat --style=plain --language=man'";
      PAGER = "bat --paging=always --style=plain";
    };

    sessionPath = [
      "$HOME/.local/sbin"
      "$HOME/.local/bin"
      "$HOME/sbin"
      "$HOME/bin"
    ];

    shellAliases = {
      l = "eza --long --icons --all --all"; # Other eza aliases are defined by home-manager's eza module.
    };

    shell.enableZshIntegration = true;
  };

  # TODO: Add following
  # great history ✅
  # history substring search ✅
  # fast syntax highlighting ✅
  # auto suggestions ✅
  # completion
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autocd = true;

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      size = 50000;
      save = 50000;
      share = true;
      append = true;
      ignoreAllDups = true;
    };

    # Plugin order matters: autosuggestions first, then the syntax highlighter,
    # then hss last (hss must load after the highlighter).
    antidote = {
      enable = true;

      plugins = [
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting"
        "zsh-users/zsh-history-substring-search"
      ];
    };

    initContent = lib.mkMerge [
      # Before antidote (550) so the plugin picks it up when it loads
      (lib.mkOrder 500 ''
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=blue,fg=black,bold";
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold";
        ZSH_AUTOSUGGEST_STRATEGY=(history completion) # history first, completion as fallback
      '')

      ''
        bindkey "$terminfo[kcuu1]" history-substring-search-up   # Up arrow
        bindkey "$terminfo[kcud1]" history-substring-search-down # Down arrow
      ''
    ];
  };

  programs.bat.enable = true;

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  programs.eza.enable = true;
  programs.eza.extraOptions = [ "--group-directories-first" ];

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zoxide.options = [ "--cmd cd" ];

  programs.mise.enable = true;
  programs.mise.enableZshIntegration = true;
  programs.mise.globalConfig = {
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

  # Extra config files

  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workplace/MyNIXOS/hypr/hyprland.lua";
}
