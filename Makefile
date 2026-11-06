REGISTRY_URL ?= harbor.infra.evertrust.io/platform

.PHONY: fetch-dependencies build cleanup-dependencies list-targets

SHELL = /bin/bash
TARGETS = $(shell ls targets/)
PLATFORM = linux/amd64
BASE_IMAGE = 
BUILD_PUSH = 1
SKIP_DEPENDENCIES = 0

fetch-dependencies: ## Fetch third-party dependencies
	@for target in ${TARGETS}; do \
	if [ -f targets/$$target/dependencies.txt ]; then \
		echo "Pulling dependencies for $$target"; \
		pushd targets/$$target; \
		while read dep; do \
			oras pull "$(REGISTRY_URL)/$${dep##*/}"; \
		done < dependencies.txt; \
		popd; \
	fi; \
	done

build: ## Build all images for a given base image
	@if [ -z "${BASE_IMAGE}" ]; then echo "Please specify the source image using the BASE_IMAGE env variable" && exit 1; fi; \
	if [ ${SKIP_DEPENDENCIES} -eq 0 ]; then $(MAKE) fetch-dependencies; fi
	@for target in ${TARGETS}; do \
		IMAGE_TAG=${BASE_IMAGE}-$$target; \
		pushd targets/$$target; \
		docker build --platform ${PLATFORM} --tag $$IMAGE_TAG --build-arg BASE_IMAGE=${BASE_IMAGE} $$(env | grep -E "^$$(echo $$target | tr '[:lower:]' '[:upper:]')_" | sed 's/^/--build-arg /') .; \
		if [ ${BUILD_PUSH} -eq 1 ]; then \
			docker push $$IMAGE_TAG; \
		fi; \
		popd; \
	done
	if [ ${SKIP_DEPENDENCIES} -eq 0 ]; then $(MAKE) cleanup-dependencies; fi

cleanup-dependencies: ## Cleanup third-party dependencies
	@for target in ${TARGETS}; do \
	if [ -f targets/$$target/dependencies.txt ]; then \
		echo "Cleaning up dependencies for $$target"; \
		pushd targets/$$target; \
		while read dep; do \
			rm $${dep#*:}; \
		done < dependencies.txt; \
		popd; \
	fi; \
	done

list-targets: ## List all available targets
	@echo "Available targets:"
	@for target in ${TARGETS}; do \
		echo "  $$target"; \
	done
