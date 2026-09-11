# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixosvm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."ali" = {
    isNormalUser = true;
    description = "Ali Aminfar";
    extraGroups = [ "networkmanager" "wheel" ];
    # Login shell stays bash (POSIX) rather than fish: tools that run a
    # non-interactive SSH command against this account -- VS Code
    # Remote-SSH's server bootstrap, scp, git, ansible -- pipe bash/sh
    # syntax into the login shell's stdin. Fish can't parse that and just
    # hangs with no output until the caller times out (this is what broke
    # Remote-SSH after fish was set as the login shell). Interactive
    # sessions still land in fish via the exec below.
  };

  # Required so fish is registered in /etc/shells and available system-wide
  # (not just in ali's home-manager profile).
  programs.fish.enable = true;

  # Auto-exec into fish for interactive shells only, leaving non-interactive
  # bash sessions (see note above) untouched.
  programs.bash.interactiveShellInit = ''
    if [[ $- == *i* ]] && [[ -z "$FISH_VERSION" ]] && [[ -z "$BASH_EXECUTION_STRING" ]]; then
      exec ${pkgs.fish}/bin/fish
    fi
  '';

  services.vscode-server.enable = true;

  # Lets unpatched, dynamically-linked generic-Linux binaries run on NixOS:
  # VSCode extensions that download their own language-server binaries, and
  # mise-installed toolchains (precompiled node/python builds expect a
  # standard FHS dynamic linker path). See https://nix.dev/permalink/stub-ld
  programs.nix-ld.enable = true;

  # Hyprland, launched via UWSM (systemd-integrated session management).
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.defaultSession = "hyprland-uwsm";

  # SDDM theme from https://github.com/Darkkal44/qylock
  # Disabled: the "sword" theme's greeter animation pegs 3+ CPU cores
  # continuously whenever the login screen is left unattended (this VM is
  # normally only accessed via SSH/VS Code Remote, never at the console),
  # which starved the vscode-server setup and caused Remote-SSH timeouts.
  # programs.qylock = {
  #   enable = true;
  #   theme = "sword";
  #   quickshell.enable = false; # only the SDDM greeter theme, not the Quickshell lockscreen
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
