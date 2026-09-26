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
  # completion ✅
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autocd = true;

    # compinit is run by zephyr's completion plugin inside the antidote list
    # (fzf-tab must load after compinit), so drop home-manager's own call, which
    # would otherwise run after all plugins. enableCompletion stays on for
    # nix-zsh-completions and the fpath setup.
    completionInit = "";

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      size = 50000;
      save = 50000;
      share = true;
      append = true;
      ignoreAllDups = true;
    };

    # Plugin order matters:
    # - completion definitions must be on fpath before compinit
    # - zephyr runs compinit, then fzf-tab, then fzf-tab-source (its
    #   descriptions format must override zephyr's compstyle)
    # - fzf-tab before the widget wrappers: autosuggestions, then the syntax
    #   highlighter, then hss last (hss must load after the highlighter).
    antidote = {
      enable = true;

      plugins = [
        "zsh-users/zsh-completions kind:fpath path:src"
        "mattmc3/zephyr path:plugins/completion"
        "${pkgs.zsh-fzf-tab}/share/fzf-tab"
        "Freed-Wu/fzf-tab-source"
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting"
        "zsh-users/zsh-history-substring-search"
      ];
    };

    initContent = lib.mkMerge [
      # Before antidote (550) so the plugins pick these up when they load
      (lib.mkOrder 500 (builtins.readFile ./zsh/pre-plugin.zsh))
      (builtins.readFile ./zsh/post-plugin.zsh)
    ];
  };

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.bat.enable = true;

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  # Generates LS_COLORS at build time, shared by zsh completion, fzf-tab and eza.
  programs.vivid = {
    enable = true;
    enableZshIntegration = true;
    activeTheme = "ayu";
  };

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
