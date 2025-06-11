{ config, pkgs, lib, ... }:

let
  USERNAME = "pi-zero";
in
{
  imports = [
    ../../config/default.nix
    ../../modules/camera/module.nix
  ];

  config = {
    _config = {
      user = {
        name = USERNAME;
      };
      
      networking = {
        hostName = USERNAME;
        staticIp = "192.168.50.26";
      };
    };

    _pi = {
      configTxt = (builtins.readFile ./config.txt);
      deviceTreeFilter = "bcm2837-rpi-zero-2*";
      camera = {
        users = [
          USERNAME
        ];
        dtsCompatible = "brcm,bcm2837";
      };
    };

    boot = {
      kernelPackages = pkgs.linuxPackages_rpi02w;
    };
  };
}
