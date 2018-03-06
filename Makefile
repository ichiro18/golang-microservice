APP?=go-microservice
NAMESPACE?=github.com/ichiro18
PROJECT?=${NAMESPACE}/${APP}
RELEASE?=0.0.1
COMMIT?=$(shell git rev-parse --short HEAD)
REPO?=$(shell git config --get remote.origin.url)
PORT?=8080
VERSION_FLAGS?=-ldflags "\
	-X ${PROJECT}/version.RELEASE=${RELEASE} \
	-X ${PROJECT}/version.COMMIT=${COMMIT} \
	-X ${PROJECT}/version.REPO=${REPO}"

clean:
	if [ -f ${APP} ] ; then rm ${APP} ; fi

build: clean
	go build ${VERSION_FLAGS} -o ${APP}

run: build
	SERVICE_PORT=${PORT} ./${APP}

install:
	go install ${VERSION_FLAGS}

test:
	go test -v
