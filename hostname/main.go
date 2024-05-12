package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
)

var hostname string
var logSourceIp *bool = new(bool)

func handleHostname(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	var attrs = make([]any, 0, 8)
	attrs = append(attrs, "hostname", hostname, "path", r.URL.Path)

	if *logSourceIp {
		attrs = append(attrs, "ip", r.RemoteAddr, "forwarded-for", r.Header.Get("X-Forwarded-For"))
	}

	slog.Info("hostname request", attrs...)

	w.Header().Set("Content-Type", "text/plain")
	w.WriteHeader(http.StatusOK)
	_, err := w.Write([]byte(hostname))
	if err != nil {
		log.Println(err)
	}
}
func handleHealth(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	w.Header().Set("Content-Type", "text/plain")

	var msg string
	if hostname == "" {
		msg = "not ok"
		w.WriteHeader(http.StatusInternalServerError)
	} else {
		msg = "ok"
		w.WriteHeader(http.StatusOK)
	}

	slog.Info("healthcheck request", "status", msg)

	_, err := w.Write([]byte(msg))
	if err != nil {
		log.Println(err)
	}
}

func handleNotFound(w http.ResponseWriter, _ *http.Request) {
	w.WriteHeader(404)
}

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, os.Kill)
	defer cancel()

	// try find it on ENV
	*logSourceIp = false
	hostname = os.Getenv("HOSTNAME")
	var err error

	if os.Getenv("LOG_SOURCE_IP") != "" && os.Getenv("LOG_SOURCE_IP") != "0" && os.Getenv("LOG_SOURCE_IP") != "false" {
		*logSourceIp = true
	}

	// read hostname from file
	if hostname == "" {
		if hostname, err = fromFile("/etc/hostname"); err != nil {
			slog.Error("unable to read hostname from /etc/hostname", "error", err)
			os.Exit(1)
		}
	}

	// setup server
	port := os.Getenv("PORT")
	if port == "" {
		port = "80"
	}

	server := &http.Server{
		Addr: fmt.Sprintf(":%s", port),
	}

	mux := http.NewServeMux()
	mux.HandleFunc("GET /", handleHostname)
	mux.HandleFunc("GET /hostname", handleHostname)
	mux.HandleFunc("GET /healthz", handleHealth)
	mux.HandleFunc("GET /{catchall}", handleNotFound)

	server.Handler = mux

	go func() {
		<-ctx.Done()
		log.Println("shutting down server")
		err := server.Shutdown(ctx)
		if err != nil {
			log.Println("error shutting down http server:", err)
		}
	}()

	slog.Info("http server started", "port", port)
	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatalln(err)
	}
}

func fromFile(p string) (string, error) {
	f, err := os.Open(p)
	if err != nil {
		return "", err
	}
	defer f.Close()

	b, err := io.ReadAll(f)
	if err != nil {
		return "", err
	}
	hostname = string(b)

	return hostname, nil
}
