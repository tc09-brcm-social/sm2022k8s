#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/sminfra/backend.sh \
    | bash ../common/sminfra/ssofbService.sh
