# Define variables
REGISTRY_URL ?= ghcr.io
REGISTRY_USERNAME ?= joseamador95
IMAGE_NAME = $(REGISTRY_URL)/$(REGISTRY_USERNAME)/ceedling
CEEDLING_SCRIPT = ceedling.sh
CEEDLING_RELEASE_URL = https://api.github.com/repos/ThrowTheSwitch/Ceedling/releases
DESTINATION_PATH ?=

# Determine the Ceedling version
ifeq ($(VERSION),)
    CEEDLING_VERSION := $(shell curl --silent "$(CEEDLING_RELEASE_URL)" | \
        grep '"tag_name":' | \
        sed -E 's/.*"([^"]+)".*/\1/' | \
        head -n 1)
else
    CEEDLING_VERSION := $(VERSION)
endif

# Determine the destination path based on the operating system
UNAME_S := $(shell uname)
ifeq ($(DESTINATION_PATH),)
    ifeq ($(UNAME_S),Darwin)
        DESTINATION_PATH = /usr/local/bin/ceedling
    endif
    ifeq ($(UNAME_S),Linux)
        DESTINATION_PATH = /usr/local/bin/ceedling
    endif
    ifneq (,$(filter CYGWIN% MINGW% MSYS%,$(UNAME_S)))
        DESTINATION_PATH = /usr/bin/ceedling
    endif
endif

# Default target
.PHONY: all
all: build install test

# Build the container image
.PHONY: build
build:
	@echo "Building Ceedling version: $(CEEDLING_VERSION)" && \
	CONTAINER_RUNTIME=$${CONTAINER_RUNTIME:-$${RUNTIME:-podman}} && \
	$${CONTAINER_RUNTIME} build \
		--build-arg CEEDLING_VERSION="$(CEEDLING_VERSION)" \
		-t "$(IMAGE_NAME):$(CEEDLING_VERSION)" \
		.

# Install the ceedling script (depends on build)
.PHONY: install
install: build
	cp $(CEEDLING_SCRIPT) $(CEEDLING_SCRIPT).tmp && \
	sed "s|^IMAGE_NAME=.*|IMAGE_NAME=\"$(IMAGE_NAME):$(CEEDLING_VERSION)\"|" $(CEEDLING_SCRIPT).tmp > $(CEEDLING_SCRIPT).tmp.new && \
	mv $(CEEDLING_SCRIPT).tmp.new $(CEEDLING_SCRIPT).tmp && \
	sudo install -m 755 $(CEEDLING_SCRIPT).tmp $(DESTINATION_PATH) && \
	rm -f $(CEEDLING_SCRIPT).tmp && \
	echo "Installed ceedling to $(DESTINATION_PATH)"

# Test the ceedling script
.PHONY: test
test:
	@echo "Testing Ceedling version: $(CEEDLING_VERSION)" && \
	ceedling --version | grep -q "Ceedling => $(CEEDLING_VERSION)" && \
	echo "Ceedling version $(CEEDLING_VERSION) is correct ✅" || \
	(echo "Ceedling version $(CEEDLING_VERSION) is incorrect ❌" && exit 1)

# Uninstall the ceedling script
.PHONY: uninstall
uninstall:
	sudo rm -f $(DESTINATION_PATH)
	echo "Uninstalled ceedling from $(DESTINATION_PATH)"

# Clean the container image and relevant build cache
.PHONY: clean
clean:
	CONTAINER_RUNTIME=$${CONTAINER_RUNTIME:-$${RUNTIME:-podman}} && \
	$${CONTAINER_RUNTIME} rmi -f "$(IMAGE_NAME):$(CEEDLING_VERSION)" && \
	$${CONTAINER_RUNTIME} builder prune --filter "label=build=$(IMAGE_NAME)" -f
