package main

import (
	"os"

	"github.com/sirupsen/logrus"
	"github.com/takama/router"
	"github.com/ichiro18/go-microservice/version"
)

var log = logrus.New()

func main() {
	port := os.Getenv("SERVICE_PORT")
	if len(port) == 0 {
		log.Fatal("Requirement parameter SERVICE_PORT is not set")
	}
	log.Printf(
		"Starting the service...\ncommit: %s, build time: %s, release: %s",
		version.Commit, version.BuildTime, version.Release,
	)
	r := router.New()
	r.Logger = logger
	r.GET("/", home)

	r.Listen("0.0.0.0:" + port)
}
