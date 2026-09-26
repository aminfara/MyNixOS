# Sourced after antidote loads the plugins: key bindings for plugin widgets and
# zstyles that must override what the plugins set while loading (same pattern,
# last write wins).

bindkey "$terminfo[kcuu1]" history-substring-search-up   # Up arrow
bindkey "$terminfo[kcud1]" history-substring-search-down # Down arrow

# fzf-tab needs zsh's own menu off so it can take over (and insert the
# unambiguous prefix first). Zephyr's compstyle turns it on for these.
zstyle ':completion:*' menu no
zstyle ':completion:*:*:(kill|man):*' menu no
zstyle ':completion:*:*:cd:*:directory-stack' menu no

# Group headers become fzf-tab's $group, which fzf-tab-source matches
# on (e.g. 'process ID') and which can't carry %F colours. Zephyr's
# generic format is looked up before the descriptions one, so drop it.
zstyle -d ':completion:*' format
zstyle ':completion:*:corrections' format '%d (errors: %e)'

# Tab/Space/Enter accept; zsh then adds the usual space (or / for dirs).
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept' 'space:accept'
zstyle ':fzf-tab:*' switch-group '<' '>'

# Replaces fzf-tab-source's generic preview (less + lesspipe): eza for
# directories, bat for files. (Its config-directory override skips the
# home-manager symlinks, so it is set here instead.)
zstyle ':fzf-tab:complete:*' fzf-preview '
  p=${realpath#-*=}
  if [[ -d $p ]]; then
    command eza -1 --color=always --icons --group-directories-first -- $p
  elif [[ -f $p ]]; then
    command bat --color=always --style=numbers --line-range=:200 -- $p
  fi'

# Replaces fzf-tab-source's man preview, which only matches the group
# 'manual page'; zephyr's separate-sections makes it 'manual page,
# section N (...)', so take the section from there.
zstyle ':fzf-tab:complete:(\\|*/|)man:' fzf-preview '
  [[ $group == "manual page"* ]] || return
  [[ $group == *", section "* ]] && s=${${group#*, section }%% *}
  MANWIDTH=$FZF_PREVIEW_COLUMNS command man $s $word 2>/dev/null |
    command bat --color=always --plain --language=man'

# fzf-tab-source has no preview for parameters: show the value.
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'

# Drop the completion dump and restart the shell to rebuild it from scratch.
zcompreset() { command rm -f -- "$ZSH_COMPDUMP"{,.zwc,.fpath}; exec zsh }
