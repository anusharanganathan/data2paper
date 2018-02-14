#!/bin/bash

set -eo pipefail

# Check that the Fedora Commons Rest interface is running
FEDORA=$(curl  -I -s -L http://localhost:8080/rest/ | grep -o "HTTP/1.1 200")

if [ "$FEDORA" = "HTTP/1.1 200" ] ; then
    exit 0
fi
exit 1
