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

var (
	hostname    string
	logSourceIp bool
)

// Handlers
func handleHostname(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	attrs := []any{
		"hostname", hostname, "path", r.URL.Path,
	}
	if logSourceIp {
		attrs = append(attrs, "ip", r.RemoteAddr, "forwarded-for", r.Header.Get("X-Forwarded-For"))
	}
	slog.Info("hostname request", attrs...)

	w.Header().Set("Content-Type", "text/plain")
	w.WriteHeader(http.StatusOK)
	if _, err := w.Write([]byte(hostname)); err != nil {
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
	if _, err := w.Write([]byte(msg)); err != nil {
		log.Println(err)
	}
}

func handleNotFound(w http.ResponseWriter, _ *http.Request) {
	w.WriteHeader(http.StatusNotFound)
}

// Utility function to read hostname from file
func fromFile(path string) (string, error) {
	f, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer f.Close()

	b, err := io.ReadAll(f)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

// Setup configuration from environment variables/files
func initConfig() {
	logSourceIp = os.Getenv("LOG_SOURCE_IP") != "" &&
		os.Getenv("LOG_SOURCE_IP") != "0" &&
		os.Getenv("LOG_SOURCE_IP") != "false"

	hostname = os.Getenv("HOSTNAME")
	if hostname == "" {
		var err error
		if hostname, err = fromFile("/etc/hostname"); err != nil {
			slog.Error("unable to read hostname from /etc/hostname", "error", err)
			os.Exit(1)
		}
	}
}

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, os.Kill)
	defer cancel()

	initConfig()

	// Create server and handlers
	port := os.Getenv("PORT")
	if port == "" {
		port = "80"
	}
	addr := fmt.Sprintf(":%s", port)

	mux := http.NewServeMux()
	mux.HandleFunc("GET /", handleHostname)
	mux.HandleFunc("GET /hostname", handleHostname)
	mux.HandleFunc("GET /healthz", handleHealth)
	mux.HandleFunc("GET /{catchall}", handleNotFound)

	server := &http.Server{
		Addr:    addr,
		Handler: mux,
	}

	// Context for graceful shutdown
	go func() {
		<-ctx.Done()
		log.Println("shutting down server")
		if err := server.Shutdown(ctx); err != nil {
			log.Println("error shutting down http server:", err)
		}
	}()

	slog.Info("http server started", "port", port)
	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatalln(err)
	}
}
