#
# See ./CONTRIBUTING.rst
#

OS := $(shell uname)
.PHONY: help
.DEFAULT_GOAL := help

HAS_PIP := $(shell command -v pip;)
HAS_PIPENV := $(shell command -v pipenv;)

ifdef HAS_PIPENV
	PIPENV_RUN:=pipenv run
	PIPENV_INSTALL:=pipenv install
else
	PIPENV_RUN:=
	PIPENV_INSTALL:=
endif

TEAM := equipindustry
REPOSITORY_DOMAIN:=github.com
REPOSITORY_OWNER:=${TEAM}
PROJECT := visanetgo
PROJECT_PORT := 3000

PYTHON_VERSION=3.8.0
NODE_VERSION=12.14.1
PYENV_NAME="${PROJECT}"

# Configuration.
SHELL ?=/bin/bash
ROOT_DIR=$(shell pwd)
MESSAGE:=🍺️
MESSAGE_HAPPY:="Done! ${MESSAGE}, Now Happy Hacking"
SOURCE_DIR=$(ROOT_DIR)/
PROVISION_DIR:=$(ROOT_DIR)/provision
FILE_README:=$(ROOT_DIR)/README.rst

PATH_DOCKER_COMPOSE:=docker-compose.yml -f provision/docker-compose

DOCKER_SERVICE_DEV:=app
DOCKER_SERVICE_TEST:=app
DOCKER_SERVICE_YARN:=nodejs

docker-compose:=$(PIPENV_RUN) docker-compose

docker-test:=$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/test.yml
docker-dev:=$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/dev.yml

docker-test-run:=$(docker-test) run --rm ${DOCKER_SERVICE_TEST}
docker-dev-run:=$(docker-dev) run --rm --service-ports ${DOCKER_SERVICE_DEV}
docker-yarn-run:=$(docker-dev) run --rm --service-ports ${DOCKER_SERVICE_YARN}


include provision/make/*.mk

help:
	@echo '${MESSAGE} Makefile for ${PROJECT}'
	@echo ''
	@echo 'Usage:'
	@echo '    environment               create environment with pyenv'
	@echo '    setup                     install requirements'
	@echo ''
	@make alias.help
	@make docs.help
	@make test.help
	@make services.help

setup:
	@echo "=====> install packages..."
	pyenv local ${PYTHON_VERSION}
	yarn install
	$(PIPENV_INSTALL) --dev --skip-lock
	$(PIPENV_RUN) pre-commit install
	$(PIPENV_RUN) pre-commit install -t pre-push
	@cp -rf provision/git/hooks/prepare-commit-msg .git/hooks/
	@[ -e ".env" ] || cp -rf .env.example .env
	@go mod vendor
	@echo ${MESSAGE_HAPPY}

environment:
	@echo "=====> loading virtualenv ${PYENV_NAME}..."
	pyenv local ${PYTHON_VERSION}
	@pipenv --venv || $(PIPENV_INSTALL) --python=${PYTHON_VERSION} --skip-lock
	@echo ${MESSAGE_HAPPY}

.PHONY: format
format:
	@find . -type f -name "*.go*" -print0 | xargs -0 gofmt -s -w

.PHONY: bench
bench:
	GOPATH=$(GOPATH) go test -bench=. -check.b -benchmem

# Clean junk
.PHONY: clean
clean:
	GOPATH=$(GOPATH) go clean ./...
