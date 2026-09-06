# zoxide — fish integration provides `z`/`zi`; fish.nix aliases cd/cdi to
# them (a `cd` alias, not abbr, so shell history still records `cd`).
{ ... }:
{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
