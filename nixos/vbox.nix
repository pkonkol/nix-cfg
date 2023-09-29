{ config, pkgs, ...}:

with pkgs.lib;

{
    imports = [ ];

    users.extraUsers.freiherr.extraGroups = [ "vboxsf" ];
    #services.xserver.videoDrivers = mkOverride 40 [ "virtualbox" "vmware" "cirrus" "vesa" ];

    
    # virutalbox-image.nix
    #fileSystems."/".device = "/dev/disk/by-label/nixos";
  
    #boot.loader.grub.version = 2;
    #boot.loader.grub.device = "/dev/sda";
  
    #services.virtualbox.enable = true;

}
