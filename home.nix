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
      nixfmt
      nixd
      claude-code
      ghostty
      stylua
      lua-language-server

      # CLI Tools
      # TODO: Check if there is options way for each
      # git, delta, lazygit, btop, yazi moved to their own programs.* below,
      # for the shell/git integration those options give.
      fd
      neovim
      ripgrep

      # Required by the OMZ `extract` plugin for the archive types it
      # doesn't already cover via tar/gzip/bzip2/xz/zstd/cpio (all in the
      # base system closure already).
      unzip # .zip/.jar/.war/.apk/...
      p7zip # .7z, provides `7za`
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
    # - completion definitions must be on fpath before compinit. extract's
    #   `_extract` uses the passive `#compdef` header form, only picked up by
    #   compinit's own fpath scan, so its dir needs a kind:fpath entry here
    #   too (git/sudo call `compdef` live instead, which works from anywhere
    #   after compinit has run).
    # - zephyr runs compinit, then fzf-tab, then fzf-tab-source (its
    #   descriptions format must override zephyr's compstyle)
    # - the OMZ plugins define widgets (sudo, copybuffer) that need to exist
    #   before the wrappers below load
    # - fzf-tab before the widget wrappers: autosuggestions, then the syntax
    #   highlighter, then hss last (hss must load after the highlighter).
    antidote = {
      enable = true;

      plugins = [
        "zsh-users/zsh-completions kind:fpath path:src"
        "ohmyzsh/ohmyzsh kind:fpath path:plugins/extract"
        "mattmc3/zephyr path:plugins/completion"
        "mattmc3/zephyr path:plugins/editor"
        "mattmc3/zephyr path:plugins/directory"
        "${pkgs.zsh-fzf-tab}/share/fzf-tab"
        "Freed-Wu/fzf-tab-source"
        "ohmyzsh/ohmyzsh path:lib/clipboard.zsh" # clipcopy/clippaste, used by git's gbcopy and copypath/copybuffer below
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/sudo"
        "ohmyzsh/ohmyzsh path:plugins/extract"
        "ohmyzsh/ohmyzsh path:plugins/copypath"
        "ohmyzsh/ohmyzsh path:plugins/copybuffer"
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

  # Writes ~/.config/git/config (XDG path, not ~/.gitconfig). Git reads both
  # if both exist -- XDG one first, then ~/.gitconfig -- so the pre-existing
  # ~/.gitconfig (same userName/userEmail) keeps working and isn't touched;
  # it's redundant now and can be removed whenever convenient.
  programs.git = {
    enable = true;
    settings.user = {
      name = "Ali 🚶";
      email = "ali.aminfar@gmail.com";
    };
  };

  # Wires delta in as git's pager for diff/blame/log/show and as the
  # interactive-staging diff filter (programs.git.iniContent).
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # enableZshIntegration wraps lazygit in a shell function (default: `lg`)
  # that cds the shell to wherever lazygit's "exit to dir" left you.
  programs.lazygit.enable = true;
  programs.lazygit.enableZshIntegration = true;

  # enableZshIntegration wraps yazi in a shell function (default: `y`) that
  # cds the shell into wherever you navigated to when you quit yazi.
  programs.yazi.enable = true;
  programs.yazi.enableZshIntegration = true;

  # Settings/themes left at defaults; configure later.
  programs.btop.enable = true;

  # Extra config files

  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workplace/MyNIXOS/hypr/hyprland.lua";
}
