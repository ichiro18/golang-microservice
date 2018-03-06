# ==========================================	Переменные		==========================================
# Настройка namespaces
APP?=go-microservice
NAMESPACE?=github.com/ichiro18
PROJECT?=${NAMESPACE}/${APP}

# Параметры версионности
RELEASE?=0.0.1
COMMIT?=$(shell git rev-parse --short HEAD)
REPO?=$(shell git config --get remote.origin.url)
VERSION_FLAGS?=-ldflags "\
	-X ${PROJECT}/version.RELEASE=${RELEASE} \
	-X ${PROJECT}/version.COMMIT=${COMMIT} \
	-X ${PROJECT}/version.REPO=${REPO}"

# Параметры кросс-компиляции
GOOS?=linux
GOARCH?=amd64

# Параметры микросервиса
PORT?=8000


# ==========================================	Сценарии		==========================================

# Удаляем старое
clean:
	docker stop ${APP}:${RELEASE} || true && docker image rm ${APP}:${RELEASE} || true
	if [ -f ${APP} ] ; then rm ${APP} ; fi

# Сборка
build: clean
	CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build ${VERSION_FLAGS} -o ${APP}

# Контейнеризация
container: build
	docker build -t ${APP}:${RELEASE} .

# Запуск
run: container
	docker stop $(APP):$(RELEASE) || true && docker rm $(APP):$(RELEASE) || true
	docker run --name ${APP} -p ${PORT}:${PORT} --rm -e "PORT=${PORT}" ${APP}:${RELEASE}

install:
	go install ${VERSION_FLAGS}

test:
	go test -v
