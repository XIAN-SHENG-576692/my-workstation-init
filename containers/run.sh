#!/bin/sh

set -euo pipefail

REQUIRED_CMDS="
podman
"

# Usage help function
usage() {
    cat << EOF
Usage: ${0##*/} [OPTIONS]
    Run the container for the specified operating system.

Prerequisites:
$(printf '    - %s\n' ${REQUIRED_CMDS})

Options:
    -o, --os       Choose OS
    -h, --help     Display this help message
EOF
    exit 1
}

for cmd in $REQUIRED_CMDS; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: required command '$cmd' not found." >&2
        usage
    fi
done

# ==================================================
# Configure parameters
if [ "$#" -eq 0 ]; then
    usage
fi

OS=""

# Parse command-line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -o|--os)
            shift
            OS="$1"
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown option $1"
            usage
            ;;
    esac
done

# Validate that inputs are not empty
if [ -z "${OS}" ]; then
    echo "Error: The OS are required."
    echo ""
    usage
fi

# ==================================================
# SCRIPT_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==================================================
# Configuration
REPO_ROOT_DIR=$(cd "${SCRIPT_DIR}/.."; pwd)

INIT_DIR=$(cd "${REPO_ROOT_DIR}/init"; pwd)
SCRIPTS_DIR=$(cd "${REPO_ROOT_DIR}/scripts"; pwd)
WORKSPACE_DIR="${REPO_ROOT_DIR}/workspace"

IMAGE="${OS}:latest"
CONTAINER_NAME="my-workstation-env-container-${OS}"

if podman container exists "${CONTAINER_NAME}"; then
	echo "${CONTAINER_NAME} already exists."
	exit 1
fi

mkdir -p "${WORKSPACE_DIR}"

podman run \
	-d \
	-v "${INIT_DIR}":/workstation/init:ro,z,U \
	-v "${SCRIPTS_DIR}":/workstation/scripts:ro,z,U \
	-v "${WORKSPACE_DIR}":/workstation/workspace:z,U \
	-w /workstation/workspace \
	--cap-add=SYS_PTRACE \
	--group-add=keep-groups \
	--mount=type=bind,src=/dev/bus/usb,dst=/dev/bus/usb,rw \
	--name "${CONTAINER_NAME}" \
	--net=host \
	--privileged \
	--security-opt label=disable \
	--security-opt seccomp=unconfined \
	--tmpfs /tmp \
	--volume=/run/udev:/run/udev:ro \
	"${IMAGE}" \
	tail -f /dev/null
