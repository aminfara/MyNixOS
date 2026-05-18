{ ... }:

{
  imports = [
    ./bootloader.nix
    ./locale.nix
    ./users.nix
    ./desktop.nix
    ../packages.nix
  ];
}
