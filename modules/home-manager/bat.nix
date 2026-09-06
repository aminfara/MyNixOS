# bat — used directly, and as the pager behind man/PAGER below. `cat`
# is aliased to it in fish.nix instead of here, since that's fish's own
# alias namespace (not a bat setting).
{ ... }:
{
  programs.bat.enable = true;

  home.sessionVariables = {
    MANROFFOPT = "-c"; # prevent raw escape codes in man pages piped through bat
    BAT_PAGER = "less";
    MANPAGER = "sh -c 'col -bx | bat --style=plain --language=man'";
    PAGER = "bat --paging=always --style=plain";
  };
}
