{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-vscode-server doesn't declare its own nixpkgs input, so there's
    # nothing to follow here.
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;

      # Builds one NixOS host, wiring in the shared nixos/home-manager
      # modules plus each user's account + home config for that host.
      # Optional per-(host,user) overrides are picked up automatically if
      # present: hosts/<hostname>/users/<user>/account.nix (NixOS module)
      # and hosts/<hostname>/users/<user>/home.nix (home-manager module).
      mkHost = { hostname, system ? "x86_64-linux", users }:
        let
          hostUserOverride = kind: user:
            let path = ./hosts/${hostname}/users/${user}/${kind}.nix;
            in lib.optional (builtins.pathExists path) path;
        in
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostname}
            ./modules/nixos
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users = lib.genAttrs users (user: {
                imports = [
                  ./modules/home-manager
                  ./users/${user}/home.nix
                ] ++ hostUserOverride "home" user;
              });
            }
          ]
          ++ map (user: ./users/${user}/account.nix) users
          ++ lib.concatMap (hostUserOverride "account") users;
        };
    in
    {
      nixosConfigurations = {
        skypc = mkHost {
          hostname = "skypc";
          users = [ "ali" ];
        };
      };
    };
}
