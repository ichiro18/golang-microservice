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

# Параметры компиляции
GOOS?=linux
GOARCH?=amd64
CONTAINER_IMAGE?=docker.io/ilyamachetto/${APP}

# Параметры микросервиса
PORT?=8000


# ==========================================	Сценарии		==========================================
# Устанавливаем нужные зависимости
vendor:
	go get -u github.com/golang/dep/cmd/dep
	dep ensure
# Удаляем старое
clean: vendor
	docker stop ${APP}:${RELEASE} || true && docker image rm ${APP}:${RELEASE} || true
	if [ -f ${APP} ] ; then rm ${APP} ; fi

# Сборка
build: clean
	CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build ${VERSION_FLAGS} -o ${APP}

# Контейнеризация
container: build
	docker build -t ${CONTAINER_IMAGE}:${RELEASE} .

# Запуск
run: container
	docker stop $(APP):$(RELEASE) || true && docker rm $(APP):$(RELEASE) || true
	docker run --name ${APP} -p ${PORT}:${PORT} --rm -e "PORT=${PORT}" ${APP}:${RELEASE}

push: container
	docker push ${CONTAINER_IMAGE}:${RELEASE}

minikube: push
	for t in $(shell find ./provision/kubernetes -type f -name "*.yaml"); do \
		cat $$t | \
			sed s/'{{ .ServiceName }}'/${APP}/ | \
			sed s/'{{ .Release }}'/${RELEASE}/; \
		echo '\n'; \
	done > tmp.yaml
	kubectl apply -f tmp.yaml
	echo "\n $(shell minikube ip) ${APP}.local" | sudo tee -a /etc/hosts


install:
	go install ${VERSION_FLAGS}

test:
	go test -v
