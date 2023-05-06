package main

import "net/http"

func main() {

	http.ListenAndServe(":8035", http.FileServer(http.Dir("./html")))
}
