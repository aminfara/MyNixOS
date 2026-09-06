# NixOS user account for ali, shared by every host they're on.
{ pkgs, ... }:
{
  users.users.ali = {
    isNormalUser = true;
    description = "Ali Aminfar";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };
}
