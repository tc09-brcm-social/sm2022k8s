#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
BASENAME="$(echo "$(basename "$1")" | sed 's/\.debug$//')"
mkdir -p "$BASENAME"
cd "$BASENAME"
DEBUG="../$1"
csplit "$DEBUG" -f file '/^---$/' '/^NOTES:$/' \
    && bash "$MYPATH"/yamlsplit.sh file01 xx \
    && cat xx* | grep -E '^kind|^  name:|^type|^metadata:$' > summary
