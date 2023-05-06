.DEFAULT_GOAL := build
# SHELL := /bin/bash
TARGETOS := linux
TARGETARCH := amd64
APP_PFX :=
ARCH := $(word 2,$(MAKECMDGOALS))
ifeq (${ARCH},)
ARCH := ${TARGETARCH}
endif

format:
	gofmt -s -w ./src

lint:
	golint ./src

test:
	go test -v ./src

get:
	go install ./src

build: clean format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o bin/app${APP_PFX} ./src
	$(MAKE) image TARGETOS=${TARGETOS} TARGETARCH=${TARGETARCH} APP_PFX=${APP_PFX}

linux:
	$(MAKE) build TARGETOS=linux TARGETARCH=${ARCH}

windows:
	$(MAKE) build TARGETOS=windows TARGETARCH=${ARCH} APP_PFX=.exe

darwin:
	$(MAKE) build TARGETOS=darwin TARGETARCH=${ARCH}

macos: darwin

amd64:
	@TARGETARCH=${ARCH}

arm:
	@TARGETARCH=${ARCH}

arm64:
	@TARGETARCH=${ARCH}

image:
	sudo docker build . -t app:${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH} --build-arg APP_PFX=${APP_PFX}

clean:
	rm -rf bin/*
	- sudo docker rmi app:${TARGETOS}-${TARGETARCH}
