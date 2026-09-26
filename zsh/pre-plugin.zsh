# Sourced before antidote loads the plugins: settings the plugins read at load time.

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=blue,fg=black,bold"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold"
ZSH_AUTOSUGGEST_STRATEGY=(history completion) # history first, completion as fallback

zstyle ':zephyr:plugin:completion' immediate yes        # compinit in place, before fzf-tab
zstyle ':zephyr:plugin:completion' use-cache yes        # reuse dump <20h, rebuilt on fpath changes
zstyle ':zephyr:plugin:completion' use-xdg-basedirs yes # dump in ~/.cache/zsh/zcompdump
