# ==========================================	Переменные		==========================================
# Настройка namespaces
APP?=backend_go-microservice
NAMESPACE?=github.com/ichiro18
PROJECT?=${NAMESPACE}/go-microservice

# Параметры версионности
RELEASE?=0.0.1
COMMIT?=$(shell git rev-parse --short HEAD)
REPO?=$(shell git config --get remote.origin.url)
VERSION_FLAGS?=-ldflags "\
	-X ${PROJECT}/version.RELEASE=${RELEASE} \
	-X ${PROJECT}/version.COMMIT=${COMMIT} \
	-X ${PROJECT}/version.REPO=${REPO}"

# Параметры компиляции
GOOS?=linux
GOARCH?=amd64
CONTAINER_IMAGE?=ilyamachetto/${APP}

# Параметры микросервиса
PORT?=8000


# ==========================================	Сценарии		==========================================

# Удаляем старое
clean:
	if [ -n "$(shell docker ps -q -f name=${APP})" ] ; then \
		docker stop ${APP}; \
		docker image rm -f $(shell docker images ${CONTAINER_IMAGE} -q); \
	fi
	if [ -f ${APP} ] ; then rm ${APP} ; fi

# Сборка
build:
	CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build ${VERSION_FLAGS} -o ${APP}

# Контейнеризация
container: build
	docker build -t ${CONTAINER_IMAGE}:${RELEASE} .

# Запуск
run: container
	docker run -d --name ${APP} -p ${PORT}:${PORT} --rm -e "PORT=${PORT}" ${CONTAINER_IMAGE}:${RELEASE}

# Пушим в репозиторий
push: container
	docker push ${CONTAINER_IMAGE}:${RELEASE}

test:
	go test -v
