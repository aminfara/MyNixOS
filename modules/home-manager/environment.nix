# General, shell-agnostic session config — not tied to any one program or
# to fish specifically.
{ ... }:
{
  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GIT_EDITOR = "nvim";
  };
}
