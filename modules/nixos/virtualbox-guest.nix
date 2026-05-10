# VirtualBox guest additions.
# Only imported by hosts that run inside VirtualBox — not workstations or bare-metal.
{ ... }:
{
  virtualisation.virtualbox.guest = {
    enable      = true;
    dragAndDrop = true;
  };
}
