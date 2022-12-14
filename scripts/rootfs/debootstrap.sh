#!/usr/bin/env bash

echo "--- start scripts/rootfs/debootstrap.sh ---"

# debug mode = set -x = loud
DEBUG="${DEBUG:-false}"
if $DEBUG; then
  set -exu
else
  set -eu
fi

# If the script wasn't sourced we need to set DIRNAME and SCRIPT_DIR
if ! (return 0 2>/dev/null)
then
  # where this .sh file lives
  DIRNAME=$(dirname "$0")
  SCRIPT_DIR=$(cd "${DIRNAME}" || exit 1; pwd)
fi

DEFAULT_TOP_DIR=$(dirname "${SCRIPT_DIR}/../../.")
DEFAULT_TOP_DIR=$(cd "${DEFAULT_TOP_DIR}" || exit 1; pwd)
TOP_DIR="${TOP_DIR:-$DEFAULT_TOP_DIR}"

# load common functions
# default variables
. "${TOP_DIR}/scripts/common/config.sh"

# end boilerplate

# clear out old attempts
sudo rm -rfv "${ROOTFS_DIR}"

mkdir -p "${ROOTFS_DIR}"

# debootstrap it
echo "Running debootstrap for ${TARGET_DISTRO_CODENAME} into ${ROOTFS_DIR}"
sudo fakeroot debootstrap \
  --arch="${TARGET_ARCH}" \
  --include="${TARGET_ROOTFS_PACKAGES}" \
  --components="${TARGET_DEBOOTSTRAP_COMPONENTS}" \
  "${TARGET_DISTRO_CODENAME}" \
  "${ROOTFS_DIR}" \
  "${TARGET_DISTRO_MIRROR}"

echo "--- end scripts/rootfs/debootstrap.sh ---"
