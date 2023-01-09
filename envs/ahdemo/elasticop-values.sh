#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/elastic/elasticop-values.sh
#bash ../common/elastic-registry.sh \
#    | bash ../common/elastic-min.sh
