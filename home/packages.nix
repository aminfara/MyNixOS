# User-level packages — installed for `ali` on every machine.
# Neovim runtime deps (LSP servers, formatters) live in home/neovim.nix instead.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ── modern unix replacements ──────────────────────────────────────────
    eza # better ls
    bat # better cat (syntax highlighting)
    ripgrep # better grep
    fd # better find
    fzf # fuzzy finder
    zoxide # smarter cd (learns your dirs)
    delta # better git diff pager
    jq # JSON processor
    yq-go # YAML processor

    # ── system / monitoring ───────────────────────────────────────────────
    htop
    tmux

    # ── dev tools ─────────────────────────────────────────────────────────
    lazygit
  ];
}
