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
PACKAGES="
curl
"

"${REPO_SCRIPTS_DIR}/install_packages_cross_platform.sh" \
    "${PACKAGES}"

# ==================================================
# Install minijinja
curl -sSfL https://github.com/mitsuhiko/minijinja/releases/latest/download/minijinja-cli-installer.sh | sh

# ==================================================
# Export environment variables
. "${REPO_SCRIPTS_DIR}/export_minijinja-cli.env.sh"
