# ==========================================	Переменные		==========================================
# Настройка namespaces
APP?=go-microservice
NAMESPACE?=github.com/ichiro18
PROJECT?=${NAMESPACE}/${APP}

# Параметры версионности
RELEASE?=0.0.1
# Параметры компиляции
CONTAINER_IMAGE?=docker.io/ilyamachetto/${APP}

# Параметры микросервиса


# ==========================================	Сценарии		==========================================
# Устанавливаем нужные зависимости
vendor:
	go get -u github.com/golang/dep/cmd/dep
	dep ensure

# Сборка
build: vendor
	make -C ./backend push
	make -C ./frontend push

# Запуск
run: vendor
	make -C ./backend run
	make -C ./frontend run

# Остановка
stop:
	make -C ./backend clean
	make -C ./frontend clean

minikube: build
	for t in $(shell find ./provision/kubernetes -type f -name "*.yaml"); do \
		cat $$t | \
			sed s/'{{ .ServiceName }}'/${APP}/ | \
			sed s/'{{ .Release }}'/${RELEASE}/; \
		echo '\n'; \
	done > tmp.yaml
	kubectl apply -f tmp.yaml
	echo "\n $(shell minikube ip) ${APP}.local" | sudo tee -a /etc/hosts

check:
	if [ ! "$(docker ps -q -f name=frontend_go-microservice)" ] ; then echo true ; fi