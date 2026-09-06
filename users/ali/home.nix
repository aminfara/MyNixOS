# Home-manager config for ali, shared by every host they're on.
{ ... }:
{
  home.username = "ali";

  programs.bash.shellAliases = {
    glg = "git log";
  };
}
