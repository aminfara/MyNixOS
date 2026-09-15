# fzf-tab config (https://github.com/Aloxaf/fzf-tab#configure)

# zimfw/completion sets 'menu select'; fzf-tab requires 'menu no' instead,
# so override it after that plugin has loaded.
zstyle ':completion:*' menu no

# zimfw/completion only checks whether $LS_COLORS is *set*, not non-empty,
# so an empty (but exported) $LS_COLORS leaves fzf-tab's listing with no
# colors at all. Set it properly ourselves.
if [[ -n "$LS_COLORS" ]]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
else
  zstyle ':completion:*' list-colors 'di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43'
fi

# git-checkout completions are already sorted usefully; don't re-sort them
# in the fzf-tab list.
zstyle ':completion:*:git-checkout:*' sort false

zstyle ':fzf-tab:*' switch-group '<' '>'

# Space and Tab both accept the highlighted completion and insert a
# trailing space, so you can keep completing the next argument without
# pressing Tab again.
zstyle ':fzf-tab:*' fzf-flags '--bind=space:accept+print(\ ),tab:accept+print(\ )'

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'

# zsh-autosuggestions: try history first, then fall back to what
# tab-completion would suggest.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
