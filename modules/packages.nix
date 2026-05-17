{ pkgs, ... }:

{
  # System-wide Packages
  # ----------------------------------------
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    btop
    delta
    vim
    wget
  ];

}
