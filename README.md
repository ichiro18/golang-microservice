# Микросервис на GO

## Настройка окружения

1. Установка [gvm](https://github.com/moovweb/gvm)
    ```sh
    $ bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
    $ vim ~/.zshenv
    [[ -s ~/.gvm/scripts/gvm ]] && . ~/.gvm/scripts/gvm
    ```
2. Установка [direnv](https://github.com/direnv/direnv)
    ```sh
    $ sudo add-apt-repository "deb http://cz.archive.ubuntu.com/ubuntu xenial main universe"
    $ sudo apt-get update
    $ apt-get install direnv
    $ vim ~/.zshenv
    [[ -f /usr/local/bin/direnv ]] && \
      eval “$(direnv hook zsh)”
    $ vim ~/.direnvrc
    use_go(){
        . $GVM_ROOT/scripts/gvm-default
        gvm use $1
    }
    $ vim ~/.zshrc
    source ~/.zshenv
    ```
3. Устанавливаем GO
    ```sh
    gvm install go1.10 -B
    ```
4. Создаем проект
    ```sh
    $ mkdir awesome-project
    $ cd awesome-project
    $ gvm pkgset create --local
    $ gvm pkgset use --local
    $ mkdir -p ./src/$VCS_HOST/$VCS_USERNAME/$PROJECT_NAME
    $ direnv edit .
    use go go1.10
    layout go
    $ eval “$(direnv hook zsh)”
    ```
5. Открываем $PROJECT_NAME в любимом редакторе

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

$(dirname $(dirname $(dirname $(dirname "$(pwd)"))))