APP?=go-microservice
NAMESPACE?=github.com/ichiro18
PROJECT?=${NAMESPACE}/${APP}
RELEASE?=$(shell git describe --tags)
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')
PORT?=8080
VERSION_FLAGS?=-ldflags "\
	-X ${PROJECT}/version.Release=${RELEASE} \
	-X ${PROJECT}/version.Commit=${COMMIT} \
	-X ${PROJECT}/version.BuildUser=${COMMIT} \
	-X ${PROJECT}/version.BuildTime=${BUILD_TIME}"

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
