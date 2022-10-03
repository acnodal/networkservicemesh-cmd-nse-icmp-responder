PROJECT ?= cmd-nse-icmp-responder
REGISTRY ?= purelb
SUFFIX = v0.0.0-dev
IMAGE=${REGISTRY}/${PROJECT}:${SUFFIX}

.PHONY: help image install

##@ Default Goal
help: ## Display help message
	@echo "Usage:\n  make <goal> [VAR=value ...]"
	@echo "\nVariables"
	@echo "  REGISTRY       Image registry name"
	@echo "  SUFFIX         Image tag suffix (the part after ':')"
	@awk 'BEGIN {FS = "[:=].*##"}; \
		/^[A-Z]+=.*?##/ { printf "  %-15s %s\n", $$1, $$2 } \
		/^[%a-zA-Z0-9_-]+:.*?##/ { printf "  %-15s %s\n", $$1, $$2 } \
		/^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development Goals
image:
# Copy the dependencies that we "replace" to a place where the Dockerfile can see them
	mkdir -p build-tmp
	rm -rf build-tmp/*
	cp -r ../sdk build-tmp/
	docker build -t ${IMAGE} .

install:
	docker push ${IMAGE}
