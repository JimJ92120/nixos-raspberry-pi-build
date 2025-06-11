{ modulesPath, lib, ... }:

{
  nixpkgs.overlays = [
    # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  # https://discourse.nixos.org/t/nixos-on-raspberry-pi-zero-w/38018/11
  disabledModules = [
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/profiles/base.nix"
  ];

  hardware = {
    # https://github.com/NixOS/nixpkgs/issues/154163
    enableAllHardware = lib.mkForce false;
  };
}