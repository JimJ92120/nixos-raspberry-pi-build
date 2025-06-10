# nixos-raspberry-pi-build

Create **SD card** images for **Raspberry Pi's** with **NixOS**.

**Note**  
The main `config/default.nix` is currently missing, therefore all modules will not work as expected.  
`flake` based configuration may be implemented to handle different `instances` (or systems), build steps, etc.

---

# setup

```sh
git clone https://github.com/JimJ92120/nixos-raspberry-pi-build.git
```

# build

`./build.sh` allows to create an `image.img` from a given `configuration.nix` file (`$CONFIG_PATH`), then install it on a given **SD Card** (`$SD_CARD_PATH`), targetting a specific `host` system (`$TARGET_SYSTEM`).  
`image.nix` will be available in the `build/` directory.

```sh
./build.sh $CONFIG_PATH $SD_CARD_PATH $TARGET_SYSTEM

# e.g
./build.sh ./configuration.nix /dev/sda aarch64-linux

# show example
./build.sh --help
```
