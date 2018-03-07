package main

import (
	"net/http"
	"os"

	"github.com/sirupsen/logrus"
	"github.com/takama/router"
	"github.com/ichiro18/go-microservice/version"

	info_handler "github.com/ichiro18/go-microservice/common/handlers/info"
	"github.com/ichiro18/go-microservice/common/utils/shutdown"
)

var log = logrus.New()

func main() {
	port := os.Getenv("SERVICE_PORT")
	if len(port) == 0 {
		log.Fatal("Requirement parameter SERVICE_PORT is not set")
	}
	log.Printf(
		"Starting the backend service...\ncommit: %s, repo: %s, version: %s",
		version.COMMIT, version.REPO, version.RELEASE,
	)
	r := router.New()
	r.Logger = logger

	r.GET("/", home)

	// Liveness and Readiness probes for Kubernetes
	r.GET("/info", func(c *router.Control) {
		info_handler.Info(c, version.RELEASE, version.REPO, version.COMMIT)
	})
	r.GET("/status", func(c *router.Control) {
		c.Code(http.StatusOK).Body(http.StatusText(http.StatusOK))
	})

	go r.Listen("0.0.0.0:" + port)

	logger := log.WithField("event", "shutdown")
	sdHandler := shutdown.NewHandler(logger)
	sdHandler.RegisterShotdown(sd)
}

// sd does graceful dhutdown of the service
func sd() (string, error) {
	// if service has to finish some tasks before shutting down, these tasks must be finished her
	return "Ok", nil
}