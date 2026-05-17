{
  description = "MyNixOS - A Nix flake for managing my NixOS and macOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      # ---- helper for creating NixOS configurations ----
      mkNixOS =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit hostname system; };
          modules = [
            ./hosts/${hostname}/default.nix
          ];
        };

    in
    {

      # NixOS machines
      nixosConfigurations = {
        vbuddy-aarch = mkNixOS "vbuddy-aarch" "aarch64-linux";
      };

    };
}
