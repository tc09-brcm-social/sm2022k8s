#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
#bash ../common/sminfra/values.sh \
echo '{}' \
    | bash ../common/sminfra/fluentbit.sh \

# leave a blank line for the trailing \ to work

