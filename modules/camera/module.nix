{ config, pkgs, lib, ... }:

let
  packages = {
    rpicam-apps = (import ./packages/rpicam-apps.nix);
  };

  overlays = {
    ov5647 = (import ./overlays/ov5647.nix {
      compatibleWith = config._pi.camera.dtsCompatible;
    });
  };
in
{
  options = {
    _pi = {
      # deviceTreeFilter = lib.mkOption {
      #   type = lib.types.str;
      #   default = "*rpi*";
      # };
      camera = {
        users = lib.mkOption {
          type = lib.types.nullOr(lib.types.listOf(lib.types.str));
        };
        dtsCompatible = lib.mkOption {
          type = lib.types.str;
          default = "brcm,bcm2711";
        };
      };
    };
  };

  config = {
    # boot = {
    #   kernelModules = [ "bcm2835-v4l2" ];
    # };

    users = {
      groups = {
        "video" = {
          members = lib.mkIf (builtins.hasAttr "users" config._pi.camera) config._pi.camera.users;
        };
      };
    };

    environment.systemPackages = [
      packages.rpicam-apps
    ];

    services.udev = {
      extraRules = ''
        SUBSYSTEM=="dma_heap", GROUP="video", MODE="0660"
      '';
    };

    hardware = {
      deviceTree = {
        overlays = [
          {
            name = "ov5647-overlay";
            dtsFile = overlays.ov5647;
          }
        ];
      };
    };
  };
}
