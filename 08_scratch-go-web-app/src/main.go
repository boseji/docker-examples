package main

import (
	"fmt"
	"github.com/julienschmidt/httprouter"
	"log"
	"net/http"
)

func main() {
	rout := httprouter.New()
	rout.GET("/", home)
	rout.GET("/hello/:hello", hello)
	rout.GET("/about", about)

	log.Println("Starting Server (with httprouter) at 8080")
	log.Fatalln(http.ListenAndServe(":8080", rout))
}

func home(w http.ResponseWriter, _ *http.Request, _ httprouter.Params) {
	w.Header().Set("Content-Type", "text/plain")
	fmt.Fprintln(w, "Hare Krishna")
}

func hello(w http.ResponseWriter, _ *http.Request, p httprouter.Params) {
	w.Header().Set("Content-Type", "text/plain")
	fmt.Fprintf(w, "Hello, %s!", p.ByName("hello"))
}

func about(w http.ResponseWriter, _ *http.Request, _ httprouter.Params) {
	w.Header().Set("Content-Type", "text/plain")
	fmt.Fprintln(w, "About Krishna")
}
