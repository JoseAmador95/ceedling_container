#!/bin/sh

# Define the image name
IMAGE_NAME="fill/from/makefile/ceedling"

# Get the current working directory
CWD=$(pwd)

# Select container runtime (default to podman)
CONTAINER_RUNTIME="${CONTAINER_RUNTIME:-podman}"

# Additional container runtime arguments
CONTAINER_RUN_ARGS="${CONTAINER_RUN_ARGS:-}"

# Run the Ceedling container, binding the current working directory to the same location in the container
${CONTAINER_RUNTIME} run \
    --rm \
    --interactive \
    --tty \
    --volume "${CWD}:${CWD}" \
    --workdir "${CWD}" \
    --user "$(id -u):$(id -g)" \
    ${CONTAINER_RUN_ARGS} \
    "${IMAGE_NAME}" "$@"
