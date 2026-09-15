{ config, lib, ... }:

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

    # antidote's plugin block below is inserted at mkOrder 550 -- earlier
    # than home-manager's own automatic compinit (mkOrder 570). fzf-tab
    # requires compinit to have already run when it's sourced, so run it
    # ourselves just before antidote's block and disable the automatic one
    # to avoid calling it twice.
    # https://github.com/Aloxaf/fzf-tab#usage
    enableCompletion = false;
    initContent = lib.mkMerge [
      (lib.mkOrder 549 ''
        autoload -Uz compinit
        compinit
      '')

      (lib.mkOrder 900 ''
        # fzf-tab config (https://github.com/Aloxaf/fzf-tab#configure)
        zstyle ':completion:*' menu no
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        # git-checkout completions are already sorted usefully; don't re-sort.
        zstyle ':completion:*:git-checkout:*' sort false
        zstyle ':fzf-tab:*' switch-group '<' '>'
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
      '')
    ];

    antidote = {
      enable = true;
      plugins = [
        # fzf-tab must load after compinit (done above) and before any
        # plugin that wraps completion widgets, e.g. fast-syntax-highlighting.
        "Aloxaf/fzf-tab"
        "zdharma-continuum/fast-syntax-highlighting"
      ];
    };

  };
}
