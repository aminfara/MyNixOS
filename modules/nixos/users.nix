{ pkgs, settings, ... }:

{
  # User Accounts
  # ----------------------------------------
  users.users.${settings.userName} = {
    isNormalUser = true;
    description = settings.fullName;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };
}
