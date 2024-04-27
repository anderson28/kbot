DOCKERHUB_REGISTRY ?= andrulyan
GITHUB_REGISTRY    := ghcr.io/anderson28

APP        := $(shell basename $(shell git remote get-url origin) .git)
VERSION    := $(shell git describe --tags --abbrev=0)
HASH       := $(shell git rev-parse --short HEAD)
TARGETOS   ?= linux
TARGETARCH ?= amd64
FILENAME    = bin/kbot-${VERSION}-${HASH}-${TARGETOS}-${TARGETARCH}$(if $(findstring windows,$(TARGETOS)),.exe,)

DOCKERHUB_REGISTRY_TAG ?= ${DOCKERHUB_REGISTRY}/${APP}:${VERSION}-${HASH}-${TARGETOS}-${TARGETARCH}
GITHUB_REGISTRY_TAG    ?= ${GITHUB_REGISTRY}/${APP}:${VERSION}-${HASH}-${TARGETOS}-${TARGETARCH}

format:
	gofmt -s -w ./

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o ${FILENAME} -ldflags "-X github.com/anderson28/kbot/cmd.appVersion=${VERSION}-${HASH}"

image-build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X github.com/anderson28/kbot/cmd.appVersion=${VERSION}-${HASH}"

linux:
	$(MAKE) build TARGETOS=linux TARGETARCH=amd64

windows:
	$(MAKE) build TARGETOS=windows TARGETARCH=amd64

macOS:
	$(MAKE) build TARGETOS=darwin TARGETARCH=arm64

darwin:
	$(MAKE) build TARGETOS=darwin TARGETARCH=amd64

image:
	docker build ./							\
	-t ${DOCKERHUB_REGISTRY}/${APP}:latest	\
	-t ${DOCKERHUB_REGISTRY_TAG}			\
	-t ${GITHUB_REGISTRY}/${APP}:latest		\
	-t ${GITHUB_REGISTRY_TAG}				\
	--build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push ${DOCKERHUB_REGISTRY_TAG}
	docker push ${DOCKERHUB_REGISTRY}/${APP}:latest

push-gh:
	docker push ${GITHUB_REGISTRY_TAG}
	docker push ${GITHUB_REGISTRY}/${APP}:latest

lint:
	golint

test:
	go test -v

clean:
	rm -rf bin