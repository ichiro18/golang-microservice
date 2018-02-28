FROM scratch
LABEL NAME="golang-microservice"

ENV SERVICE_PORT 8000

EXPOSE $SERVICE_PORT

COPY golang-microservice /

CMD ["/golang-microservice"]