{ hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../configuration.nix
  ];

  networking.hostName = hostname; # Define your hostname.
}
