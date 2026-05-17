{
  pkgs,
  lib,
  settings,
  ...
}:

{
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  networking.hostName = "${settings.hostname}";

  networking.networkmanager.enable = true;

  time.timeZone = "${settings.timeZone}";

  i18n.defaultLocale = "${settings.locale}";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${settings.locale}";
    LC_IDENTIFICATION = "${settings.locale}";
    LC_MEASUREMENT = "${settings.locale}";
    LC_MONETARY = "${settings.locale}";
    LC_NAME = "${settings.locale}";
    LC_NUMERIC = "${settings.locale}";
    LC_PAPER = "${settings.locale}";
    LC_TELEPHONE = "${settings.locale}";
    LC_TIME = "${settings.locale}";
  };

  services.xserver.xkb = {
    layout = "${settings.keyboardLayout}";
    variant = "${settings.keyboardLayoutVariant}";
  };

  users.users.${settings.username} = {
    isNormalUser = true;
    description = "${settings.fullname}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
