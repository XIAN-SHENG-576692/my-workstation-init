#!/bin/sh

# ==================================================
# SCRIPT_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==================================================
# Configuration
REPO_ROOT_DIR=$(cd "${SCRIPT_DIR}/.."; pwd)
REPO_SCRIPTS_DIR="${REPO_ROOT_DIR}/scripts"

# ==================================================
# Install packages
PACKAGES=""

# GitHub
PACKAGES="
${PACKAGES}
git
gh
"

# Editors
PACKAGES="
${PACKAGES}
neovim
vim
"

# Clear
PACKAGES="
${PACKAGES}
libncurses5-dbg
ncurses
ncurses-bin
"

# Others
PACKAGES="
${PACKAGES}
dos2unix
jq
less
lsof
procps
psmisc
sudo
tree
unzip
util-linux
util-linux-extra
zip
"

# xz
PACKAGES="
${PACKAGES}
xz
xz-utils
"

"${REPO_SCRIPTS_DIR}/install_packages_cross_platform.sh" \
    "${PACKAGES}"
