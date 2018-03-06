package main

import (
	"net/http"
	"os"

	"github.com/sirupsen/logrus"
	"github.com/takama/router"
	"github.com/ichiro18/go-microservice/version"

	common_handlers "github.com/ichiro18/go-microservice/common/handlers"
)

var log = logrus.New()

func main() {
	port := os.Getenv("SERVICE_PORT")
	if len(port) == 0 {
		log.Fatal("Requirement parameter SERVICE_PORT is not set")
	}
	log.Printf(
		"Starting the service...\ncommit: %s, repo: %s, version: %s",
		version.COMMIT, version.REPO, version.RELEASE,
	)
	r := router.New()
	r.Logger = logger

	r.GET("/", home)

	// Liveness and Readiness probes for Kubernetes
	r.GET("/info", func(c *router.Control) {
		common_handlers.Info(c, version.RELEASE, version.REPO, version.COMMIT)
	})
	r.GET("/status", func(c *router.Control) {
		c.Code(http.StatusOK).Body(http.StatusText(http.StatusOK))
	})

	r.Listen("0.0.0.0:" + port)
}
