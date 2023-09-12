#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
echo '{}' \
    | bash ../common/nginx/default.sh \

