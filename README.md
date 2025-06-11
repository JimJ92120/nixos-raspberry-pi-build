# nixos-raspberry-pi-build

Create **SD card** images for **Raspberry Pi's** with **NixOS**.

**Note**  
`flake` based configuration may be implemented to handle different `instances` (or systems), build steps, etc.

---

# setup

### install

```sh
git clone https://github.com/JimJ92120/nixos-raspberry-pi-build.git
```

### config

#### `config/private.nix`

`config/private.nix` is meant for common yet private configuration such as credentials, networking, etc that shouldn't be public.
File is **ignored** (see `.gitignore`) by default and is only meant to be an example.

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
