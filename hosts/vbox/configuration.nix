{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./vboxsf.nix
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot"; # Ensure this matches your actual mount point
    };
    grub = {
      enable = true;
      device = "nodev"; # Use "nodev" for UEFI systems
      efiSupport = true;
      # Optional: Add a theme
      # theme = pkgs.stdenv.mkDerivation {
      #   pname = "distro-grub-themes";
      #   version = "3.1";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "AdisonCavani";
      #     repo = "distro-grub-themes";
      #     rev = "v3.1";
      #     hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
      #   };
      #   installPhase = "cp -r customize/nixos $out";
      # };
    };
  };
  # Optional: Enable Plymouth for a graphical boot experience
  # boot.plymouth = {
  #   enable = true;
  #   theme = "bgrt"; # This is the standard UEFI logo theme
  #   # themePackages = [ pkgs.adi1090x-plymouth ]; # Optional: extra fancy themes
  # };
  # boot.kernelParams = [
  #   "quiet"
  #   "splash"
  #   "boot.shell_on_fail"
  #   "loglevel=3"
  #   "rd.systemd.show_status=false"
  #   "rd.udev.log_level=3"
  #   "udev.log_priority=3"
  # ];
  # boot.consoleLogLevel = 0;
  # boot.initrd.verbose = false;

  networking.hostName = "vbox"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Sydney";

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

  services.xserver.xkb = {
    layout = "us";
    variant = "mac";
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  # Services that you want to have running on your system.

  services.openssh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ali = {
    isNormalUser = true;
    description = "Ali Aminfar";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
