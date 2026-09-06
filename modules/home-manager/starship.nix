# starship — prompt. Only wired up for fish for now (see fish.nix); add
# programs.starship.enableBashIntegration if bash ever wants it too.
{ ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
