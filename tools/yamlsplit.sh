#!/bin/bash
YAML="$1"
LEAD="$2"
cat "$YAML" | sed 's/^---$/#---/' \
    | csplit - -f "$LEAD" '/^#---$/' '{*}'
