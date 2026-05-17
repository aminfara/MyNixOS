{
  description = "A flake for my personal nix configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Per-machine configuration — created by bootstrap.sh
    localConfig = {
      url = "path:./config-override";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      localConfig,
      ...
    }:
    let
      settings = import "${localConfig}/settings.nix";
    in
    {
      nixosConfigurations.local = nixpkgs.lib.nixosSystem {
        system = builtins.trace ("System:" + toString settings.system) settings.system;
        specialArgs = { inherit settings; };
        modules = [
          "${localConfig}/hardware-configuration.nix"
          ./modules/common.nix
          "${localConfig}/extras.nix"
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit settings; };
              users = {
                ${settings.username} = import ./modules/home.nix;
              };
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
