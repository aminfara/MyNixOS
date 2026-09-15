{ config, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    # Use fast-syntax-highlighting instead (see plugins below)
    syntaxHighlighting.enable = false;

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      size = 50000;
      save = 50000;
      share = true;
      ignoreAllDups = true;
      ignoreSpace = true;
    };

    # zimfw/completion (in the antidote list below) owns compinit and sets
    # the general completion zstyles (matcher-list, colors, etc). Disable
    # home-manager's own automatic compinit so it isn't called twice.
    enableCompletion = false;
    initContent = builtins.readFile ./zsh/plugins_config.zsh;

    antidote = {
      enable = true;
      plugins = [
        # zimfw/completion must load before fzf-tab (which needs compinit
        # to have already run) and before any plugin that wraps completion
        # widgets, e.g. fast-syntax-highlighting. zsh-autosuggestions must
        # load before fast-syntax-highlighting so suggestions get
        # highlighted correctly. zsh-history-substring-search must load
        # after syntax highlighting, so it goes last of all.
        "zimfw/completion"
        "Aloxaf/fzf-tab"
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting"
        "zsh-users/zsh-history-substring-search"
      ];
    };

  };

  # enableZshIntegration alone does nothing -- home-manager's fzf module
  # gates its whole config block (package install + shell integration) on
  # `enable`, so that has to be turned on too. enableZshIntegration already
  # defaults to true once enable is, but leave it explicit.
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Ctrl-T file picker: preview directories as a tree, files with bat.
    fileWidgetOptions = [
      "--preview '[[ -d {} ]] && eza --tree --color=always --icons --level=2 {} || bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'"
    ];
  };
}
