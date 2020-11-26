export DOCKER_ORG ?= opsbot
export DOCKER_IMAGE ?= $(DOCKER_ORG)/shell
export DOCKER_TAG ?= latest
export DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE):$(DOCKER_TAG)
export DOCKER_BUILD_FLAGS =

-include $(shell curl -sSL -o .build-harness "https://raw.githubusercontent.com/opsbot/build-harness/main/templates/Makefile.build-harness"; echo .build-harness)

deps: init
	@exit 0

build: deps
	@make --no-print-directory docker:build

run:
	docker run -it ${DOCKER_IMAGE_NAME}
