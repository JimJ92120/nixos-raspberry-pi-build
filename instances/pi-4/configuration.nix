{ config, pkgs, lib, ... }:

let
  USERNAME = "pi-four";
in
{
  imports = [
    ../../config/default.nix
    ../../modules/camera/module.nix
  ];

  config = {
    _config = {
      username = USERNAME;
      hostName = USERNAME;
      ip = "192.168.50.15";
    };

    _nixos = {
      version = "25.05";
    };

    _pi = {
      configTxt = (builtins.readFile ./config.txt);
      deviceTreeFilter = "bcm2711-rpi-4*";
      camera = {
        users = [
          USERNAME
        ];
        dtsCompatible = "brcm,bcm2711";
      };
    };

    boot = {
      kernelPackages = pkgs.linuxPackages_rpi4;
    };
  };
}
