# Nix daemon settings — shared by NixOS and macOS.
# Platform differences (gc syntax) are handled with mkIf guards.
{ pkgs, lib, ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  # Automatic garbage collection — syntax differs between platforms
  nix.gc = {
    automatic = true;
  }
  // lib.optionalAttrs pkgs.stdenv.isLinux {
    dates = "weekly";
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    interval = {
      Weekday = 0;
      Hour = 2;
      Minute = 0;
    }; # Sunday 02:00
  };

  nixpkgs.config.allowUnfree = true;
}
