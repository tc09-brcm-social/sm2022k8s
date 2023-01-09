#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/nginx/values.sh 
#\
#| bash ../common/nginx/internal.sh
