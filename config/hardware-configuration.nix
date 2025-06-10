{ lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  hardware.enableRedistributableFirmware = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
    "/boot/FIRMWARE" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = ["noatime"];
    };
  };
}
