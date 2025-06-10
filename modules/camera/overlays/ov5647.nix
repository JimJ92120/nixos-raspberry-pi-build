with import <nixpkgs> {};

let
  repository = "raspberrypi/linux/";
  branch = "rpi-6.6.y";

  ov5647 = {
    dts = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/${repository}/refs/heads/${branch}/arch/arm/boot/dts/overlays/ov5647-overlay.dts";
    };
    dtsi = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/${repository}/refs/heads/${branch}/arch/arm/boot/dts/overlays/ov5647.dtsi";
    };
  };

  overlayPackage = pkgs.applyPatches {
    src = stdenv.mkDerivation {
      name = "ov5647-overlay-replace-vars";
      dontUnpack = true;
      dontBuild = true;

      installPhase = ''
        mkdir $out

        cp ${ov5647.dts} $out/ov5647-overlay.dts
      '';
    };
    
    patches = [
      (pkgs.writeTextFile {
        name = "ov5647.patch";
        # keep text indentation, otherwise patch is not valid
        text = ''
diff --git a/ov5647-overlay.dts b/ov5647-overlay.dts
index e2d40da..f25226f 100644
--- a/ov5647-overlay.dts
+++ b/ov5647-overlay.dts
@@ -4,7 +4,7 @@
 /plugin/;
 
 /{
-	compatible = "brcm,bcm2835";
+	compatible = "@compatible@";
 
 	i2c_frag: fragment@0 {
 		target = <&i2c_csi_dsi>;
@@ -13,7 +13,7 @@
 			#size-cells = <0>;
 			status = "okay";
 
-			#include "ov5647.dtsi"
+			@ov5647-dtsi@
 
 			vcm_node: ad5398@c {
 				compatible = "adi,ad5398";
        '';
      })
    ];
  };


in
{ compatibleWith }:
pkgs.replaceVars "${overlayPackage}/ov5647-overlay.dts" {
  compatible = compatibleWith;
  ov5647-dtsi = builtins.readFile ov5647.dtsi;
}
