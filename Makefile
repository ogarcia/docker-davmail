ALPINE_VERSION ?= latest
ifndef DAVMAIL_VERSION
DAVMAIL_RELEASE := $(shell curl -fsSL 'https://sourceforge.net/projects/davmail/rss?path=/davmail' | sed -n 's|.*<title><!\[CDATA\[/davmail/[0-9.]*/davmail-\([0-9.]*\)-\([0-9]*\)\.zip\]\]></title>.*|\1 \2|p' | awk 'NR == 1')
DAVMAIL_VERSION := $(word 1,$(DAVMAIL_RELEASE))
DAVMAIL_REVISION := $(word 2,$(DAVMAIL_RELEASE))
endif
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
