#!/bin/sh

# docker entrypoint.sh

# Define a function to handle termination signals
handle_signal() {
  echo "Caught signal, shutting down..."
  if [ -n "$child_pid" ]; then
    kill "$child_pid"
    wait "$child_pid"
    exit $?
  fi
  exit 0
}

# Trap signals
trap 'handle_signal' INT TERM QUIT HUP USR1 USR2

# Execute /main (always) and track its PID for signal handling
exec /main &
child_pid=$!

# Wait for the background process to finish, propagate its exit status
wait "$child_pid"
exit $?
