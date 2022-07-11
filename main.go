package main

import (
	"fmt"
	"net/http"
	"os"
)

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "hello\n")
}

func main() {
	// Cloud run expects to be able to set the PORT env var and have the container
	// listen on that port. This defaults to 8080 if it isn't set
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	port = fmt.Sprintf(":%s", port)
	// setup a basic handler and start the server
	http.HandleFunc("/", hello)
	http.ListenAndServe(port, nil)
}
