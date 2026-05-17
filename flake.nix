{
  description = "MyNixOS - A Nix flake for managing my NixOS and macOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      defaultSettings = {
        timeZone = "Australia/Sydney";
        userName = "ali";
        fullName = "Ali Aminfar";
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
            ./hosts/${hostName}/default.nix
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
