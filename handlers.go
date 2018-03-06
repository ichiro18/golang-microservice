package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/ichiro18/go-microservice/version"
	"github.com/takama/router"
)

func home(c *router.Control) {
	info := struct {
		BuildTime string `json:"buildTime"`
		Commit    string `json:"commit"`
		Release   string `json:"release"`
	}{
		version.BuildTime, version.Commit, version.Release,
	}

	body, err := json.Marshal(info)
	if err != nil{
		log.Printf("Could not encode info data: %v", err)
		fmt.Fprintf(c.Writer, "ERROR: %", http.StatusServiceUnavailable)
		return
	}

	fmt.Fprintf(c.Writer, "Version \n %s", body)
}

func logger(c *router.Control) {
	remoteAddr := c.Request.Header.Get("X-Forwarded-For")
	if remoteAddr == "" {
		remoteAddr = c.Request.RemoteAddr
	}
	log.Infof("%s %s %s", remoteAddr, c.Request.Method, c.Request.URL.Path)
}