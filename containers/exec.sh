#!/bin/sh

set -euo pipefail

REQUIRED_CMDS="
podman
"

# Usage help function
usage() {
    cat << EOF
Usage: ${0##*/} [OPTIONS]
    Execute the container for the specified operating system.

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

CONTAINER_NAME="my-workstation-env-container-${OS}"

if ! podman container exists "${CONTAINER_NAME}"; then
	echo "${CONTAINER_NAME} doesn't exist."
	exit 1
fi

podman start \
	"${CONTAINER_NAME}"

podman exec \
	-it \
	"${CONTAINER_NAME}" \
	/bin/bash
