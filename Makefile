include .env
CONTAINER_ORGANIZATION := connectical
CONTAINER_IMAGE := davmail
CONTAINER_ARCHITECTURES := linux/amd64,linux/arm64,linux/arm/v7

all: build

build:
	docker build -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --build-arg DAVMAIL_VERSION=$(DAVMAIL_VERSION) --build-arg DAVMAIL_REVISION=$(DAVMAIL_REVISION) .

build-multiarch:
	docker buildx build -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE) --platform $(CONTAINER_ARCHITECTURES) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --build-arg DAVMAIL_VERSION=$(DAVMAIL_VERSION) --build-arg DAVMAIL_REVISION=$(DAVMAIL_REVISION) .

.PHONY: all build build-multiarch
# vim:ft=make
