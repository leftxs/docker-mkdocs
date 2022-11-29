# The shell we use
SHELL := /bin/bash

# We like colors
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`

# Vars
NAME = mkd
DOCKER := $(bash docker)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
.PHONY: help
help: ## This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build-image
build-image: ## Build docker image
	@docker build --no-cache=true -t $(NAME) -f Dockerfile .

.PHONY: serve
serve: ## Start in development (serve) mode
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs $(NAME)

.PHONY: build-docs
build-docs: ## Build docs
	docker run --rm -it -p 8000:8000 -v ${PWD}:/docs $(NAME) build
