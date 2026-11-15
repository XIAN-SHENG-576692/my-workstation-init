#!/bin/sh

# ==================================================
# SCRIPT_DIR
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

# ==================================================
# Configuration
REPO_ROOT_DIR=$(cd "${SCRIPT_DIR}/.."; pwd)
REPO_SCRIPTS_DIR="${REPO_ROOT_DIR}/scripts"

# ==================================================
# Install packages
PACKAGES="
curl
"

"${REPO_SCRIPTS_DIR}/install_packages_cross_platform.sh" \
    "${PACKAGES}"

# ==================================================
# Install cargo-binstall
curl \
    -L \
    --proto '=https' \
    --tlsv1.2 \
    -sSf \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
    | bash
