#!/bin/bash

# Define the name of the Docker image
IMAGE_NAME="ndk-builder:latest"

# Define a name for the container for easier management
CONTAINER_NAME="ndk-builder-$(basename "$(pwd)")"

echo "--- Starting NDK build environment ---"
echo "Host path '$(pwd)' will be mounted to '/src' in the container."
echo "To exit the container, type 'exit'."

# Run the Docker container
# --rm: Automatically remove the container when it exits
# -it: Interactive mode
# -v: Mount current directory to /src in the container
# -u: Run as the current user to avoid file permission issues
# --name: Assign a name to the container
docker run \
    --rm \
    -it \
    -v "$(pwd)":/src \
    -v /home/"$(id -un)"/.cache/bazel:/home/"$(id -un)"/.cache/bazel \
    -u "$(id -u):$(id -g)" \
    --name "${CONTAINER_NAME}" \
    "${IMAGE_NAME}"
