package main

import (
	"net/http"
	"testing"
	"net/http/httptest"
	"io/ioutil"
	"strings"
	"github.com/takama/router"
	"bytes"
	"github.com/sirupsen/logrus"
	"encoding/json"
)

var buffer bytes.Buffer

func init()  {
	log.Out = &buffer
	log.Formatter = &logrus.JSONFormatter{}
}

func TestHandler(t *testing.T) {
	r := router.New()
	r.GET("/", home)

	ts := httptest.NewServer(r)
	defer ts.Close()

	res, err := http.Get(ts.URL + "/")
	if err != nil{
		t.Fatal(err)
	}

	greeting, err := ioutil.ReadAll(res.Body)
	res.Body.Close()

	if err != nil{
		t.Fatal(err)
	}

	expectedGreeting := "Frontend URL /..."
	testingGreeting  := strings.Trim(string(greeting), " \n")

	if string(expectedGreeting)!= testingGreeting{
		t.Fatalf(
			"Wrong greeting '%s', expected '%s'",
			testingGreeting, expectedGreeting,
		)
	}
}

func TestLogger(t *testing.T) {
	r := router.New()
	r.Logger = logger

	ts := httptest.NewServer(r)
	defer ts.Close()

	_, err := http.Get(ts.URL  + "/")
	if err != nil{
		t.Fatal(err)
	}

	formatted := struct {
		Level string `json:"level"`
		Msg   string `json:"msg"`
		Time  string `json:"time"`
	}{}

	err = json.NewDecoder(&buffer).Decode(&formatted)
	if err != nil {
		t.Fatal(err)
	}

	msgPart := strings.Split(formatted.Msg, " ")
	if len(msgPart) != 3{
		t.Fatalf("Wrong message was logged: %s", formatted.Msg)
	}
}