FROM scratch
LABEL NAME="go-microservice"

ENV SERVICE_PORT 8000

EXPOSE $SERVICE_PORT

COPY go-microservice /

CMD ["/go-microservice"]