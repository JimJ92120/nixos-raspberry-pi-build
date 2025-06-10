CONFIG_PATH=$1
SD_CARD_PATH=$2
TARGET_SYSTEM=$3

IMAGE_NAME=image.img
BUILD_DIRECTORY=build

# 
if [[ "--help" == $1 ]]; then
  echo "./build.sh \$CONFIG_PATH \$SD_CARD_PATH \$TARGET_SYSTEM"
  echo "e.g \"./build.sh ./configuration.nix /dev/sda aarch64-linux\""

  exit
fi

# 
if [[ -z $CONFIG_PATH ]]; then
  echo "missing \$CONFIG_PATH, e.g \"/path/to/configuration.nix\""

  exit
fi
if [[ -z $SD_CARD_PATH ]]; then
  echo "missing \$SD_CARD_PATH, e.g \"/dev/sda\""

  exit
fi
if [[ -z $TARGET_SYSTEM ]]; then
  echo "missing \$TARGET_SYSTEM, e.g \"aarch64-linux\""

  exit
fi

export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1

rm -rf result ${BUILD_DIRECTORY}

nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=$CONFIG_PATH --option system $TARGET_SYSTEM --extra-platforms $TARGET_SYSTEM --option sandbox false

mkdir -p ${BUILD_DIRECTORY}
cp result/sd-image/nixos-image-*.img ${BUILD_DIRECTORY}/${IMAGE_NAME}
rm -rf result

sudo dd if="${BUILD_DIRECTORY}/${IMAGE_NAME}" of=$SD_CARD_PATH bs=4096 conv=fsync status=progress
