{ config, lib, ... }:

{
  options = {
    _config = {
      user = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "nixos";
        };
        password = lib.mkOption {
          type = lib.types.str;
          default = "password";
        };
        sshKey = lib.mkOption {
          type = lib.types.str;
          default = "ssh-ed25519 ...";
        };
      };

      ssh = {
        port = lib.mkOption {
          type = lib.types.int;
          default = 1234;
        };
      };

      networking = {
        staticIp = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.123";
        };
        defaultGateway = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.1";
        };
        defaultInterface = lib.mkOption {
          type = lib.types.str;
          default = "wlan0";
        };
      };

      wireless = {
        ssid = lib.mkOption {
          type = lib.types.str;
          default = "My Network";
        };
        psk = lib.mkOption {
          type = lib.types.str;
          default = "abcdefg";
        };
      };
    };
  };

  config = {
    users = {
      mutableUsers = true;

      users."${config._config.user.name}" = {
        isNormalUser = true;
        initialPassword  = config._config.user.password;
        extraGroups = [
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          config._config.user.sshKey
        ];
      };
    };

    services.openssh = {
      enable = true;
      ports = [ 
        config._config.ssh.port
      ];
    };

    networking = {
      useDHCP = lib.mkForce false;

      nameservers = [
        config._config.networking.defaultGateway
      ];
      defaultGateway = {
        address = config._config.networking.defaultGateway;
        interface = config._config.networking.defaultInterface ;
      };

      interfaces = {
        "${config._config.networking.defaultInterface}" = {
          useDHCP = lib.mkForce false;

          ipv4.addresses = [{
            address = config._config.networking.staticIp;
            prefixLength = 24;
          }];
        };
      };

      firewall = {
        allowedTCPPorts = [
          config._config.ssh.port
        ];
      };
      
      wireless = {
        enable = true;

        networks."${config._config.wireless.ssid}" = {
          hidden = true;
          psk = config._config.wireless.psk;
        };
      };      
    };
  };
}
