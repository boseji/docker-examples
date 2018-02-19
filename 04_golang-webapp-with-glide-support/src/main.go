package main

import (
	"fmt"
	"github.com/julienschmidt/httprouter"
	"log"
	"net/http"
)

func home(w http.ResponseWriter, _ *http.Request, _ httprouter.Params) {
	w.Header().Add("Content-Type", "text/plain")
	fmt.Fprint(w, "Hari Aum")
}

func about(w http.ResponseWriter, _ *http.Request, _ httprouter.Params) {
	w.Header().Add("Content-Type", "text/plain")
	fmt.Fprint(w, "About Krishna")
}

func Hello(w http.ResponseWriter, _ *http.Request, ps httprouter.Params) {
	fmt.Fprintf(w, "Hello, %s!\n", ps.ByName("name"))
}

func main() {
	router := httprouter.New()
	router.GET("/", home)
	router.GET("/hello/:name", Hello)
	router.GET("/about", about)

	log.Println("Starting Server (with httprouter) on Port 8080")
	log.Fatalln(http.ListenAndServe(":8080", router))
}
