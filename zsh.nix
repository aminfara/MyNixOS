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
    initContent = builtins.readFile ./zsh/zstyles.zsh;

    antidote = {
      enable = true;
      plugins = [
        # zimfw/completion must load before fzf-tab (which needs compinit
        # to have already run) and before any plugin that wraps completion
        # widgets, e.g. fast-syntax-highlighting. zsh-autosuggestions must
        # load before fast-syntax-highlighting so suggestions get
        # highlighted correctly, and fast-syntax-highlighting must stay
        # last since it wraps zle widgets from everything before it.
        "zimfw/completion"
        "Aloxaf/fzf-tab"
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting"
      ];
    };

  };
}
