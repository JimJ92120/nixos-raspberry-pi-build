{ config, pkgs, lib, ... }:

{
  imports = [
    ./image.nix
    ./fix.nix
    ./hardware-configuration.nix
    ./private.nix
  ];

  options = {
    _config = {
      networking = {
        hostName = lib.mkOption {
          type = lib.types.str;
        };
      };
    };

    _nixos = {
      version = lib.mkOption {
        type = lib.types.str;
        default = "25.05";
      };
    };

    _pi = {
      deviceTreeFilter = lib.mkOption {
        type = lib.types.str;
        default = "*rpi*";
      };
    };
  };

  config = {
    system.stateVersion = config._nixos.version;

    boot = {
      loader = {
        grub.enable = lib.mkDefault false;
        generic-extlinux-compatible.enable = lib.mkDefault true;
      };
    };

    hardware = {
      deviceTree = {
        enable = true;
        filter = lib.mkDefault config._pi.deviceTreeFilter;
      };
    };

    environment.systemPackages = with pkgs;  [
      htop
      nano
      nmap
      nettools
      iputils
      unzip
      usbutils
      git
      #
      libraspberrypi
      raspberrypi-eeprom
      i2c-tools
    ];

    services.openssh = lib.mkIf config.services.openssh.enable {
      settings = {
        PasswordAuthentication = lib.mkForce false;
        KbdInteractiveAuthentication = lib.mkForce false;
        PermitRootLogin = lib.mkForce "no";
        KexAlgorithms = [
          # ssh-ed25519
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
        ];
      };
    };

    networking = {
      hostName = config._config.networking.hostName;

      firewall = {
        enable = true;

        allowedTCPPorts = [];
        allowedUDPPorts = [];
      };    
    };
  };
}
