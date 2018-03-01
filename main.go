package main

import (
	"github.com/takama/router"
	"github.com/sirupsen/logrus"
	"os"
)

var log = logrus.New()

func main() {
	port := os.Getenv("SERVICE_PORT")
	if len(port)  == 0{
		log.Fatal("Requirement parameter SERVICE_PORT is not set")
	}

	r:= router.New()
	r.Logger = logger
	r.GET("/", home)

	r.Listen("0.0.0.0:" + port)
}