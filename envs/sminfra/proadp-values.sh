#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
#bash ../common/sminfra/values.sh \
echo '{}' \
    | bash ../common/sminfra/proadp.sh \

# leave a blank line to allow the trailing \ to work
