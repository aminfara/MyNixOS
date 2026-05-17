{ pkgs, settings, ... }:

{
  imports = [
    ./git.nix
  ];

  # Home Manager Configuration
  # ----------------------------------------
  home = {
    username = settings.userName;
    # Darwin puts home dirs under /Users; Linux under /home
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${settings.userName}" else "/home/${settings.userName}";

    # Set once when this account is first created — do not change afterwards.
    # See: https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone
    stateVersion = "25.11";
  };
}
