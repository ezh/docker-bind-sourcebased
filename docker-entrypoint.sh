#!/bin/bash

set -e

# If user don't provide any command
# start the BIND server
# Run as user "bind"
if [[ "$1" == "" ]]; then
    echo "Starting BIND"
    exec gosu bind named
else
    # Else allow the user to run arbitrarily commands like bash
    exec "$@"
fi
