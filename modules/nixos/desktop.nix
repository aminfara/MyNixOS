{ lib, pkgs, ... }:

let
  # TODO: try qylock
  sddmTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = "astronaut";
    themeConfig = {
      PartialBlur = "false";
      FormPosition = "center"; # left, center, right
    };
  };
in
{
  environment.systemPackages = [
    sddmTheme
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    enableHidpi = true;
    package = lib.mkForce pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    settings.Theme.CursorTheme = "Bibata-Modern-Classic";
    settings.General.InputMethod = "qtvirtualkeyboard";

    extraPackages = with pkgs; [
      bibata-cursors
      kdePackages.qtsvg
      kdePackages.qtmultimedia
      kdePackages.qtvirtualkeyboard
      kdePackages.qtdeclarative
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav
    ];
  };

  systemd.services.display-manager.environment = {
    QT_IM_MODULE = "qtvirtualkeyboard";
    QT_VIRTUALKEYBOARD_DESKTOP_DISABLE = "1";
  };

}
