#!/bin/sh

# ==================================================
# SCRIPT_DIR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==================================================
# Configuration
REPO_ROOT_DIR=$(cd "${SCRIPT_DIR}/.."; pwd)

INIT_DIR=$(cd "${REPO_ROOT_DIR}/init"; pwd)
SCRIPTS_DIR=$(cd "${REPO_ROOT_DIR}/scripts"; pwd)
WORKSPACE_DIR="${REPO_ROOT_DIR}/workspace"

IMAGE="fedora:latest"
CONTAINER_NAME="my-workstation-env-container"

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
