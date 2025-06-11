# nixos-raspberry-pi-build

Create **SD card** images for **Raspberry Pi's** with **NixOS**.

**Note**  
`flake` based configuration may be implemented to handle different `instances` (or systems), build steps, etc.

---

# setup

## install

```sh
git clone https://github.com/JimJ92120/nixos-raspberry-pi-build.git
```

## config

### config/private.nix

`config/private.nix` is meant for common yet private configuration such as credentials, networking, etc that shouldn't be public.
File is **ignored** (see `.gitignore`) by default and is only meant to be an example.

### config.txt

`config.txt` can be added through `config._pi.configTxt` option and will be copied during the initial image build step.  
Defined variables will be appended to the existing `config.txt` (default from image build).

On the host `/boot/FIRMWARE` will be mounted and files can be edited with `root` permission.

```sh
# edit `config.txt` on build machine, with SD card still mounted
sudo mount /dev/disk/by-label/FIRMWARE /mnt
sudo nano /mnt/config.txt

# edit `config.txt` on host, after first boot
sudo nano /boot/FIRMWARE/config.txt
```

---

# build

`./build.sh` allows to create an `image.img` from a given `configuration.nix` file (`$CONFIG_PATH`), then install it on a given **SD Card** (`$SD_CARD_PATH`), targetting a specific `host` system (`$TARGET_SYSTEM`).  
The created `image.img` will be available in the `build/` directory.

```sh
./build.sh $CONFIG_PATH $SD_CARD_PATH $TARGET_SYSTEM

# e.g
./build.sh ./configuration.nix /dev/sda aarch64-linux

# show example
./build.sh --help
```

---

# directories

## config

`config/` directory are common and shared configuration which apply to all `instances/`.

## instances

`instances/` directory aims to add configuration for different systems.

## modules

`modules/` aims to re-use configuration on some `instances/`.  
If anything common and shared to all `instances/`, add it to `config/default.nix`.

### camera module

`modules/camera/module.nix` enables camera software and harware configuration.
It packages [`rpicam-apps`](https://github.com/raspberrypi/rpicam-apps) with [`libcarmera` fork](https://github.com/raspberrypi/libcamera) from **Raspberry**.
Overlays are compatible with `6.6` kernel only, available on `25.05` `rpi-*` kernels (e.g `pkgs.linuxPackages_rpi4`).

To check if the camera is detected, run:

```sh
rpicam-hello --list-cameras
```

##### config.txt required variables

```conf
camera_auto_detect=0
gpu_mem=128
dtoverlay=ov5647 # or others
disable_fw_kms_setup=1 # must be set on the fresh install, if set after the 1st boot, camera won't be deteced
cma=256
```

##### supported overlays

- `ov5647`

---
