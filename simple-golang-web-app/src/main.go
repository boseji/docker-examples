package main

import (
	"fmt"
	"log"
	"net/http"
)

func home(w http.ResponseWriter, req *http.Request) {
	w.Header().Add("Content-Type", "text/plain")
	fmt.Fprint(w, "Hari Aum")
}

func main() {
	http.HandleFunc("/", home)
	log.Println("Starting Server on Port 8080")
	log.Fatalln(http.ListenAndServe(":8080", nil))
}
