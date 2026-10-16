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

PACKAGES="
${PACKAGES}
curl
"

# Fix 
# - Error: failed to record pid-managed app-server process 410 startup: failed to invoke ps for pid-managed app server: No such file or directory (os error 2)
#   To work without the background server, rerun the same command with --no-daemon (including resume or fork and its arguments). 
PACKAGES="
${PACKAGES}
procps
"

"${REPO_SCRIPTS_DIR}/install_packages_cross_platform.sh" \
    "${PACKAGES}"

# ==================================================
# Install codex
sh -c 'curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh'

# ==================================================
# Export environment variables
. "${REPO_SCRIPTS_DIR}/export_codex.env.sh"
