# Микросервис на GO

### Собираем проект
```sh
GOOS=linux CGO_ENABLED=0 go build
```

### Собираем образ Docker
```sh
docker build -t golang-microservice -f ./Dockerfile .
```

### Запускаем контейнер
```sh
docker run --name golang-microservice -p 8080:8000 golang-microservice
```