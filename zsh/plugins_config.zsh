# Post-load config for the plugins in the antidote list in zsh.nix. Order
# in this file doesn't matter -- what matters is where each plugin sits in
# that list, since that's commented there.

# fzf-tab (https://github.com/Aloxaf/fzf-tab#configure)

# zimfw/completion sets 'menu select'; fzf-tab requires 'menu no' instead,
# so override it after that plugin has loaded.
zstyle ':completion:*' menu no

# zimfw/completion's descriptions format uses '%F{yellow}-- %d --%f' prompt
# color codes, but fzf-tab prints group headers without percent-expanding
# them, so they show up as literal text. fzf-tab already colors each group
# header itself, so just drop the color codes rather than hardcode one --
# hardcoding a color here would override fzf-tab's per-group coloring.
zstyle ':completion:*:descriptions' format '[ %d ]'

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

# Fallback preview for every other completion whose candidate resolves to a
# real path (files, other commands' path arguments, etc): directories as a
# tree, files with bat. Defined after the cd-specific style above since
# zstyle uses the first matching pattern, so cd keeps its own preview.
zstyle ':fzf-tab:*' fzf-preview '[[ -d $realpath ]] && eza --tree --color=always --icons --level=2 $realpath || bat --color=always --style=numbers --line-range=:500 $realpath 2>/dev/null || echo $realpath'

# zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)

# Try history first, then fall back to what tab-completion would suggest.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# zsh-history-substring-search (https://github.com/zsh-users/zsh-history-substring-search)

# Up/Down cycle through history entries matching what's already typed,
# instead of the whole line.
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
