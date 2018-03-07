FROM scratch
LABEL NAME="go-microservice-frontend"

ENV SERVICE_PORT 9000

EXPOSE $SERVICE_PORT

COPY ./frontend_go-microservice /

CMD ["/frontend_go-microservice"]