{
  pkgs,
  settings,
  config,
  ...
}:

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

    file.".config/hypr".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.mynixos/config/hypr";

    # Set once when this account is first created — do not change afterwards.
    # See: https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone
    stateVersion = "25.11";
  };
}
