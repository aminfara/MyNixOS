{ pkgs, ... }:

{
  # System-wide Packages
  # ----------------------------------------
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    btop
    vim
    wget
  ];

}
