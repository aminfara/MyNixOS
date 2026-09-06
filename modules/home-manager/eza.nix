# eza — fish gets its own ls/lsi/ll/la/l aliases (fish.nix) with flags
# spelled out per-entry, instead of eza's built-in fish integration.
{ ... }:
{
  programs.eza = {
    enable = true;
    enableFishIntegration = false;
  };
}
