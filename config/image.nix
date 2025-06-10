{ modulesPath, config, lib, ... }:

{
  options = {
    _pi = {
      configTxt = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };
  };

  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  # fix kernel not compiling
  disabledModules = [
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/profiles/base.nix"
  ];

  config = {
    system.copySystemConfiguration = lib.mkForce true;

    sdImage = {
      compressImage = false;

      # https://github.com/plmercereau/nixos-pi-zero-2/blob/main/sd-image.nix#L19-L41
      populateFirmwareCommands = lib.mkIf ("" != config._pi.configTxt) (
        lib.mkAfter ''
          config=firmware/config.txt
          # The initial file has just been created without write permissions. Add them to be able to append the file.
          chmod u+w $config
          echo "" >> $config
          echo "${config._pi.configTxt}" >> $config
          chmod u-w $config
        ''
      );
    };
  };
}
