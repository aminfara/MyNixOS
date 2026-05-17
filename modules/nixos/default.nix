{ ... }:

{
  imports = [
    ./bootloader.nix
    ./locale.nix
    ./users.nix
    ../packages.nix
  ];
}
