REGISTRY := andrulyan

APP		 := $(shell basename $(shell git remote get-url origin) .git)
VERSION  := $(shell git describe --tags --abbrev=0)
HASH 	 := $(shell git rev-parse --short HEAD)
TARGOS   := ${shell uname | tr '[:upper:]' '[:lower:]'}
TARGARCH := ${shell dpkg --print-architecture}
FILENAME = bin/kbot-${VERSION}-${HASH}-${TARGOS}-$(shell uname -m)$(if $(findstring windows,$(TARGOS)),.exe,)

format:
	gofmt -s -w ./

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGOS} GOARCH=${TARGARCH} go build -v -o ${FILENAME} -ldflags "-X github.com/anderson28/kbot/cmd.appVersion=${VERSION}-${HASH}"

image-build: format get
	CGO_ENABLED=0 GOOS=${TARGOS} GOARCH=${TARGARCH} go build -v -o kbot -ldflags "-X github.com/anderson28/kbot/cmd.appVersion=${VERSION}-${HASH}"

linux:
	$(MAKE) build TARGOS=linux TARGARCH=amd64

windows:
	$(MAKE) build TARGOS=windows TARGARCH=amd64

macOS:
	$(MAKE) build TARGOS=linux TARGARCH=arm64

darwin:
	$(MAKE) build TARGOS=darwin TARGARCH=amd64

image:
	docker build -t ${REGISTRY}/${APP}:${VERSION} .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}

lint:
	golint

test:
	go test -v

clean:
	rm -rf bin

