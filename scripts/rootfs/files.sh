#!/usr/bin/env bash

echo "--- start scripts/rootfs/files.sh ---"

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
  SCRIPT_DIR=$(cd "$DIRNAME" || exit 1; pwd)
fi

DEFAULT_TOP_DIR=$(dirname "${SCRIPT_DIR}/../../.")
DEFAULT_TOP_DIR=$(cd "$DEFAULT_TOP_DIR" || exit 1; pwd)
TOP_DIR="${TOP_DIR:-$DEFAULT_TOP_DIR}"

# load common functions
# default variables
. "${TOP_DIR}/scripts/common/config.sh"

# end boilerplate

# cd to rootfs dir
cd "${ROOTFS_DIR}" || exit 1

# copy in files
sudo /bin/cp --remove-destination -fprv "${TARGET_CONF_DIR}"/rootfs/files/* "${ROOTFS_DIR}"

# cp in kernel modules
echo "Copying in kernel modules from ${DEPLOY_DIR}/modules/"
sudo mkdir -p /mnt/lib/modules || true
sudo tar xvf "${DEPLOY_DIR}/kmod.tar" -C /mnt

echo "--- end scripts/rootfs/files.sh ---"
