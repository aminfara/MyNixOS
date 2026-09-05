{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    claude-code.url = "github:sadjow/claude-code-nix";

  };

  outputs = { self, nixpkgs, vscode-server, claude-code, ... }: {
    nixosConfigurations.skypc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        # TODO: Move to right plce
        vscode-server.nixosModules.default
        ({ config, pkgs, ... }: {
          services.vscode-server.enable = true;
        })
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ claude-code.overlays.default ];
          environment.systemPackages = [ pkgs.claude-code ];
        })
      ];
    };
  };
}
