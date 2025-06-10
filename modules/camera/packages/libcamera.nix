with import <nixpkgs> {};

pkgs.stdenv.mkDerivation {
  name = "libcamera";

  src = builtins.fetchGit { 
    url = "https://github.com/raspberrypi/libcamera.git"; 
  };

  outputs = [ "out" "dev" ];
  strictDeps = true;

  postPatch = ''
    patchShebangs src/py/ utils/
  '';

  buildInputs = with pkgs; [
    openssl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libevent
    libdrm
    systemd
    lttng-ust
    libyaml
    gtest
    libpisp
  ];

  nativeBuildInputs =  with pkgs; [
    meson
    ninja
    pkg-config
    python3
    python3Packages.jinja2
    python3Packages.pyyaml
    python3Packages.ply
    python3Packages.sphinx
    python3Packages.pybind11
    graphviz
    doxygen
    openssl
  ] ;

  mesonFlags = [
    "-Dcam=disabled"
    "-Dpipelines=rpi/vc4,rpi/pisp"
    "-Dipas=rpi/vc4,rpi/pisp"
    "-Dv4l2=enabled"
    "-Dgstreamer=disabled"
    "-Dtest=false"
    "-Dlc-compliance=disabled"
    "-Dcam=disabled"
    "-Dqcam=disabled"
    "-Ddocumentation=disabled"
    "-Dpycamera=enabled"
  ];

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-sign-compare -Wno-stringop-truncation";
  };

  meta = with lib; {
    platforms = [
      "aarch64-linux"
      "armv7l-linux"
    ];
  };
}
