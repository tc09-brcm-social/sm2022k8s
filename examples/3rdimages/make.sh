#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "$MYPATH"
bash ./images.sh \
    | awk '{print $2;}' | awk 'BEGIN{FS="\"";} { if (NF > 1) print $2; else print $1;}' \
    | sort -u
# remove the cut to retain the sha digest if any
#    | cut -d@ -f1 | sort -u
