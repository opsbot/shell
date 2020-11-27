export DOCKER_ORG ?= opsbot
export DOCKER_IMAGE ?= $(DOCKER_ORG)/shell
export DOCKER_TAG ?= latest
export DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE):$(DOCKER_TAG)
export DOCKER_BUILD_FLAGS =
export INSTALL_PATH ?= /usr/local/bin

-include $(shell curl -sSL -o .build-harness "https://raw.githubusercontent.com/opsbot/build-harness/main/templates/Makefile.build-harness"; echo .build-harness)

deps: init
	@exit 0

build: deps
	@ARGS="AWS_ACCOUNT_ID AWS_MFA_PROFILE AWS_DEFAULT_PROFILE AWS_REGION AWS_ROOT_ACCOUNT_ID S3FS_BUCKET S3FS_REGION" make --no-print-directory docker:build

install: build
	@docker run --rm $(DOCKER_IMAGE_NAME) | bash -s $(DOCKER_TAG) || (echo "Try: sudo make install"; exit 1)

run: install
	@shell
