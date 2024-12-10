# Ceedling Container

This repository provides a containerized version of Ceedling, a build system for C projects. The container can be built and used to run Ceedling commands in a consistent environment.

## Description

Ceedling is a build system designed for C projects, providing tools for unit testing, mocking, and more. This repository packages Ceedling into a container, allowing you to run Ceedling commands without needing to install it directly on your system.

## Instructions

### Building the Container

To build the Ceedling container, run the following command:

```sh
make build
```

This will build the container image using the latest Ceedling version or the version specified by the VERSION variable.

### Installing the Ceedling Script

To install the Ceedling script, run:

```sh
make install
```

This will copy the ceedling.sh script to the appropriate location on your system and configure it to use the built container image.

### Running Ceedling Commands

Once installed, you can run Ceedling commands using the ceedling script. For example:

```sh
ceedling new my_project
```

### Testing the Installation

To test that the installation is correct, run:

```sh
make test
```

This will check that the installed Ceedling script reports the correct version.

### Uninstalling the Ceedling Script

To uninstall the Ceedling script, run:

```sh
make uninstall
```

### Cleaning Up

To clean up the container image and build cache, run:

```sh
make build
```

### Configuration Options

The following variables can be configured when running make commands:

* `REGISTRY_URL`: The URL of the container registry (default: ghcr.io).
* `REGISTRY_USERNAME`: The username for the container registry (default: joseamador95).
* `VERSION`: The version of Ceedling to use (default: latest release).
* `CONTAINER_RUNTIME`: The container runtime to use (default: podman).
* `CONTAINER_RUN_ARGS`: Additional arguments to pass to the container runtime.

Example:

This will build the container image using Ceedling version 1.0.0 and Docker as the container runtime.

```sh
make build VERSION=1.0.0 CONTAINER_RUNTIME=docker
```

This will build the container image using Ceedling version 1.0.0 and Docker as the container runtime.