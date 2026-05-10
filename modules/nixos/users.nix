# Primary user account declaration.
# Password must be set imperatively with `passwd ali` after first build.
# Additional users can be added here or in a separate per-host module.
{ pkgs, ... }:
{
  programs.zsh.enable = true; # ensure zsh is installed for users' shells

  users.users.ali = {
    isNormalUser = true;
    description = "Ali A";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh; # home-manager configures zsh fully; NixOS just needs to know the shell
  };
}
