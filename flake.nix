{
  description = "A flake for my personal nix configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      # ---- helper for creating NixOS configurations for different hosts ----
      mkNixOS =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.ali = import ./home.nix;
                backupFileExtension = "backup";
              };
            }

          ];
        };
    in
    {
      nixosConfigurations = {
        vbox = mkNixOS "vbox" "x86_64-linux";
        vbuddy = mkNixOS "vbuddy" "aarch64-linux";
      };
    };
}
