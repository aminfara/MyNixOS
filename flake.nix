{
  description = "MyNixOS - A Nix flake for managing my NixOS and macOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      defaultSettings = {
        timeZone = "Australia/Sydney";
        userName = "ali";
        fullName = "Ali Aminfar";
        email = "ali.aminfar@gmail.com";
        gitName = "Ali 🚶";
        locale = "en_AU.UTF-8";
        kbdLayout = "us";
        kbdVariant = "mac";
      };
      # ---- helper for creating NixOS configurations ----
      mkNixOS =
        hostName: system: settings:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit hostName system settings; };
          modules = [
            ./hosts/${hostName}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit settings; };
              home-manager.users.${settings.userName} = import ./home;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
    in
    {

      # NixOS machines
      nixosConfigurations = {
        vbuddy-aarch = mkNixOS "vbuddy-aarch" "aarch64-linux" defaultSettings // {
          # You can override settings for this machine here, e.g.:
          # settings.timeZone = "America/New_York";
        };
      };

    };
}
