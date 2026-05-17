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
        timezone = "Australia/Sydney";
        username = "ali";
        fullname = "Ali Aminfar";
        locale = "en_AU.UTF-8";
        kbdLayout = "us";
        kbdVariant = "mac";
      };
      # ---- helper for creating NixOS configurations ----
      mkNixOS =
        hostname: system: settings:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit hostname system settings; };
          modules = [
            ./hosts/${hostname}/default.nix
          ];
        };

    in
    {

      # NixOS machines
      nixosConfigurations = {
        vbuddy-aarch = mkNixOS "vbuddy-aarch" "aarch64-linux" defaultSettings // {
          # You can override settings for this machine here, e.g.:
          # settings.timezone = "America/New_York";
        };
      };

    };
}
