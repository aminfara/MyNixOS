{ hostName, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # Machine-specific configuration`

  # Network configuration.
  networking.hostName = hostName; # Define your hostname.
  networking.networkmanager.enable = true;

  # Machine-specific services
  services.openssh.enable = true;

  system.stateVersion = "25.11"; # Keep it  https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/misc/version.nix#L228
}
