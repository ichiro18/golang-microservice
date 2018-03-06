# Микросервис на GO

### Настройка окружения

1. Установка [gvm](https://github.com/moovweb/gvm)

    ```sh
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
    ```
2. Установка [direnv](https://github.com/direnv/direnv)

    ```sh
    sudo add-apt-repository "deb http://cz.archive.ubuntu.com/ubuntu xenial main universe"
    sudo apt-get update
    apt-get install direnv
    ```
3. Настраиваем дотфайлы `~/.direnvrc`,`~/.zshenv`,`~/.zshrc.local`
   ```sh
   $ cat ~/.direnvrc
   use_go(){
    . $GVM_ROOT/scripts/gvm-default
    gvm use $1
   }

   $ cat ~/.zshenv
   [[ -s ~/.gvm/scripts/gvm ]] && . ~/.gvm/scripts/gvm
   [[ -f /usr/local/bin/direnv ]] && \
     eval “$(direnv hook $SHELL)”

   $ cat ~/.zshrc.local
   ...
   function creategoproject {
     TRAPINT() {
       print "Caught SIGINT, aborting."
       return $(( 128 + $1 ))
     }
     echo 'Creating new Go project:'
     if [ -n "$1" ]; then
       project=$1
     else
       while [[ -z "$project" ]]; do
         vared -p 'what is your project name: ' -c project;
       done
     fi
     namespace='github.com/ichiro18'
     while true; do
       vared -p 'what is your project namespace: ' -c namespace
       if [ -n "$namespace" ] ; then
          break
       fi
     done
     mkdir -p $project/src/$namespace/$project
     git init -q $project/src/$namespace/$project
     main=$project/src/$namespace/$project/main.go
     gvm pkgset create --local
     gvm pkgset use --local
     echo 'export GOPATH=$(PWD):$GOPATH' >> $project/.envrc
     echo 'export PATH=$(PWD)/bin:$PATH' >> $project/.envrc
     echo 'package main' >> $main
     echo 'import "fmt"' >> $main
     echo 'func main() {' >> $main
     echo '    fmt.Println("hello world")' >> $main
     echo '}' >> $main
     direnv allow $project
     echo "cd $project/src/$namespace/$project #to start coding"
   }
   export DIRENV_BASH=/bin/bash
   eval "$(direnv hook $SHELL)"
   ...
   $ source ~/.zshrc
   ```

4. Устанавливаем GO нужной версии (флаг -В установить только бинарники)

    ```sh
    gvm install go1.9.2 -B
    ```

4. Создаем проект
    ```sh
    creategoproject $PROJECT_NAME
    ```
5. Открываем ` $PROJECT_NAME/src/../../$PROJECT_NAME` в любимом редакторе

### Запуск
Для запуска проекта нужно запустить в терминале команду

```sh
make run
```

Открыть в браузере
- [http://localhost:8000/](http://localhost:8000)
- [http://localhost:8000/info](http://localhost:8000/info) - readiness hellcheck
- [http://localhost:8000/status](http://localhost:8000/status)  - liveness hellcheck
### TODO
- [x] Работа с менеджером зависимостей
- [x] Контейнеризация 1 демона микросервиса
- [ ] Контейнеризация нескольких демонов микросервиса
- [ ] Автоматизация установки скриптом