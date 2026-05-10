{
  description = "MyNixOS - A Nix flake for managing my NixOS and macOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let

      # ---- helper for creating NixOS configurations ----
      mkNixOS =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostname}/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ali = import ./home/default.nix;
            }
          ];
        };

      # ---- helper for creating macOS configurations ----
      mkDarwin =
        hostname: system:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ./hosts/${hostname}/default.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ali = import ./home/default.nix;
            }
          ];
        };

      # ---- helper for creating standalone home-manager configurations ----
      mkHomeConfig =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home/default.nix
          ];
        };

    in
    {

      # NixOS machines
      nixosConfigurations = {
        vbox = mkNixOS "vbox" "x86_64-linux";
      };

      # macOS machinesP
      # darwinConfigurations = {
      #   macbook = mkDarwin "macbook" "aarch64-darwin";  # Apple Silicon
      # };

      # Standalone home-manager configurations - TODO: can we unify this with the above two?
      homeConfigurations = {
        "ali@x86_64-linux" = mkHomeConfig "x86_64-linux";
      };

    };
}
