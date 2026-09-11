{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      # nixos-vscode-server does not have nixpkgs as an input, no following
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, vscode-server, claude-code, qylock, ... }: {
    nixosConfigurations.nixosvm = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        vscode-server.nixosModules.default
        # qylock.nixosModules.default # disabled: greeter animation pegs CPU when unattended
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [ claude-code.overlays.default ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ali = import ./home.nix;
        }
      ];
    };
  };
}
