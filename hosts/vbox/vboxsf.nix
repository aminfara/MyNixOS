{...}:

{
  imports = [ ];

  fileSystems."/vmshared" = {
    device = "vmshared";
    fsType = "vboxsf";
    options = [
      "nodev"
      "relatime"
      "iocharset=utf8"
      "uid=1000"
      "gid=100"
      "umask=0022"
    ];
  };

}
