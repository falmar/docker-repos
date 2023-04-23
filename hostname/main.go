package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

var hostname string

func handleHostname(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.WriteHeader(http.StatusOK)
	_, err := w.Write([]byte(hostname))
	if err != nil {
		log.Println(err)
	}
}
func handleHealth(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.WriteHeader(http.StatusOK)
	_, err := w.Write([]byte("ok"))
	if err != nil {
		log.Println(err)
	}
}

func main() {
	// read hostname
	f, err := os.Open("/etc/hostname")
	if err != nil {
		log.Fatalln(err)
	}

	b, err := io.ReadAll(f)
	if err != nil {
		_ = f.Close()
		log.Fatalln("unable to read hostname:", err)
	}
	_ = f.Close()
	hostname = string(b)

	// setup server
	port := os.Getenv("PORT")
	if port == "" {
		port = "80"
	}

	server := &http.Server{
		Addr: fmt.Sprintf(":%s", port),
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/", handleHostname)
	mux.HandleFunc("/hostname", handleHostname)
	mux.HandleFunc("/healthz", handleHealth)

	server.Handler = mux
	if err := server.ListenAndServe(); err != nil {
		log.Fatalln(err)
	}
}
