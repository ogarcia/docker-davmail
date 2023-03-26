ALPINE_VERSION := 3.17.2
DAVMAIL_VERSION := 6.1.0
DAVMAIL_REVISION := 3423
CONTAINER_ORGANIZATION := connectical
CONTAINER_IMAGE := davmail
CONTAINER_IMAGE_FILENAME ?= $(CONTAINER_ORGANIZATION)_$(CONTAINER_IMAGE).tar

all: container-build container-test

check-quay-env:
ifndef QUAY_USERNAME
	$(error QUAY_USERNAME is undefined)
endif
ifndef QUAY_PASSWORD
	$(error QUAY_PASSWORD is undefined)
endif

check-github-registry-env:
ifndef GITHUB_REGISTRY_USERNAME
	$(error GITHUB_REGISTRY_USERNAME is undefined)
endif
ifndef GITHUB_REGISTRY_PASSWORD
	$(error GITHUB_REGISTRY_PASSWORD is undefined)
endif

container-build:
	docker build -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --build-arg DAVMAIL_VERSION=$(DAVMAIL_VERSION) --build-arg DAVMAIL_REVISION=$(DAVMAIL_REVISION) .

container-test:
	docker image inspect $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE)
	docker run --name $(CONTAINER_IMAGE) -d -p 1025:1025 -p 1389:1389 -p 1110:1110 -p 1143:1143 -p 1080:1080 $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE)
	sleep 5
	ss -ltpn | grep -E "1025|1389|1110|1143|1080"
	docker kill $(CONTAINER_IMAGE)
	docker rm $(CONTAINER_IMAGE)

container-save:
	docker image inspect $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE) > /dev/null 2>&1
	docker save -o $(CONTAINER_IMAGE_FILENAME) $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE)

container-load:
ifneq ($(wildcard $(CONTAINER_IMAGE_FILENAME)),)
	docker load -i $(CONTAINER_IMAGE_FILENAME)
endif

quay-push: check-quay-env
	echo "${QUAY_PASSWORD}" | docker login -u "${QUAY_USERNAME}" --password-stdin quay.io
	docker tag $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest quay.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest
	docker push quay.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest
ifdef CIRCLE_TAG
	docker tag $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest quay.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):${CIRCLE_TAG}
	docker push quay.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):${CIRCLE_TAG}
endif

github-registry-push: check-github-registry-env
	echo "${GITHUB_REGISTRY_PASSWORD}" | docker login -u "${GITHUB_REGISTRY_USERNAME}" --password-stdin ghcr.io
	docker tag $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest ghcr.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest
	docker push ghcr.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest
ifdef CIRCLE_TAG
	docker tag $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest ghcr.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):${CIRCLE_TAG}
	docker push ghcr.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):${CIRCLE_TAG}
endif

.PHONY: all check-quay-env check-github-registry-env container-build container-test container-save quay-push github-registry-push
# vim:ft=make
