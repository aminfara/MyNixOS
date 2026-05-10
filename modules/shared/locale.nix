# Timezone and locale — same preference on every machine.
# i18n options are Linux-only; macOS handles locale through system preferences.
{ pkgs, lib, ... }:
{
  time.timeZone = "Australia/Sydney";

  i18n = lib.mkIf pkgs.stdenv.isLinux {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS        = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT    = "en_AU.UTF-8";
      LC_MONETARY       = "en_AU.UTF-8";
      LC_NAME           = "en_AU.UTF-8";
      LC_NUMERIC        = "en_AU.UTF-8";
      LC_PAPER          = "en_AU.UTF-8";
      LC_TELEPHONE      = "en_AU.UTF-8";
      LC_TIME           = "en_AU.UTF-8";
    };
  };
}
