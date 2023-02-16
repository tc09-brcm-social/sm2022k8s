#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/sminfra/values.sh \
    | bash ../common/sminfra/proadp.sh
