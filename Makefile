# Task runner

.PHONY: help build deploy

.DEFAULT_GOAL := help

SHELL := /bin/bash

# http://stackoverflow.com/questions/1404796/how-to-get-the-latest-tag-name-in-current-branch-in-git
APP_VERSION := $(shell git describe --abbrev=0)

#PROJECT_NS   := magento-dev
#CONTAINER_NS := magento-dev
GIT_HASH     := $(shell git rev-parse --short HEAD)

ANSI_TITLE        := '\e[1;32m'
ANSI_CMD          := '\e[0;32m'
ANSI_TITLE        := '\e[0;33m'
ANSI_SUBTITLE     := '\e[0;37m'
ANSI_WARNING      := '\e[1;31m'
ANSI_OFF          := '\e[0m'

PATH_DOCS                := $(shell pwd)/docs
PATH_BUILD_CONFIGURATION := $(shell pwd)/build

TIMESTAMP := $(shell date "+%s")

help: ## Show this menu
	@echo -e $(ANSI_TITLE)magento.dev$(ANSI_OFF)$(ANSI_SUBTITLE)" - A magento development environment, based on Kubernetes"$(ANSI_OFF)
	@echo -e $(ANSI_TITLE)Commands:$(ANSI_OFF)
	@grep -E '^[a-zA-Z_-%]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "    \033[32m%-30s\033[0m %s\n", $$1, $$2}'

deploy: ## Deploy the chart
	@if [[ -z "${MAGENTO_PATH}" ]]; then echo "Please supply the MAGENTO_PATH environment variable" 1>&2 && exit 1; fi;
	helm upgrade --install chart --set="mysql.mysqlRootPassword=$(pass show magento.dev/mysql/root),hostPath=${MAGENTO_PATH}" deploy/chart/
