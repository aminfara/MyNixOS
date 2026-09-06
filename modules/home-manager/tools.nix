# Plain CLI tools with no home-manager `programs.*` module of their own —
# just installed, no shell integration to configure. Tools that DO have a
# `programs.*` module (bat, eza, zoxide, starship, fish itself) live in their
# own files instead.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    btop
    lazygit
    mise
    fzf

    # Archive formats fish's `extract` function (fish/functions/extract.fish)
    # knows how to unpack.
    gnutar
    gzip
    bzip2
    xz
    zstd
    unzip
    p7zip
  ];
}
