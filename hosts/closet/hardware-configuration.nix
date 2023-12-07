{ config, lib, pkgs, modulesPath, ... }:
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
  imports =
    [ 
    "${impermanence}/nixos.nix"
    (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];


  fileSystems."/boot" =
    {
      device = "/dev/disk/by-partuuid/4d63286c-0f80-4da3-9c66-fc6ca83f3cef";
      fsType = "vfat";
    };

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [ "defaults" "mode=755" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/d760156b-3185-4ff3-8731-e9bc23264bdf";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/b1986c89-de9c-4ec0-ad76-bac2dfea0e66";
      fsType = "btrfs";
      options = [ "defaults" "compress=zstd" "noatime" "subvol=nix" ];
      neededForBoot = true;
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/b1986c89-de9c-4ec0-ad76-bac2dfea0e66";
      fsType = "btrfs";
      options = [ "defaults" "compress=zstd" "noatime" "subvol=home" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/b1986c89-de9c-4ec0-ad76-bac2dfea0e66";
      fsType = "btrfs";
      options = [ "defaults" "compress=zstd" "noatime" "subvol=persist" ];
      neededForBoot = true;
    };

  fileSystems."/etc/nixos" =
    { device = "/dev/disk/by-uuid/b1986c89-de9c-4ec0-ad76-bac2dfea0e66";
      fsType = "btrfs";
      options = [ "defaults" "compress=zstd" "noatime" "subvol=nixos-config" ];
    };

  swapDevices =
    [ { 
        device = "/dev/disk/by-partuuid/122493eb-2265-4b1f-a26d-0faf4525ef1d";
	randomEncryption.enable = true;
    } ];

  environment.persistence."/persist" = {
    directories = [
      "/etc/ssh"
      #"/etc/secrets/initrd" # uncomment if needed
      "/etc/NetworkManager"
      "/var/log"
      # "/var/lib/cups"
      # "/var/lib/fprint"
      "/var/db/sudo/lectured"
    ];
    files = [
      "/etc/machine-id"
      "/etc/nix/id_rsa"
      # "/var/lib/cups/printers.conf"
      "/var/lib/logrotate.status"
    ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
