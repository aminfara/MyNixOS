# Home Manager entry point.
# Imported for the user `ali` on every machine — NixOS and macOS alike.
{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./neovim.nix
  ];

  home.username = "ali";

  # Darwin puts home dirs under /Users; Linux under /home
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/ali" else "/home/ali";

  # Set once when this account is first created — do not change afterwards.
  # See: https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone
  home.stateVersion = "25.11";
}
