APP?=golang-microservice
PORT?=8080

clean:
	rm -f ${APP}

build: clean
	go build -o ${APP}

run:	build
	SERVICE_PORT=${PORT} ./${APP}

test:
	go test -v