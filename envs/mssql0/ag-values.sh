#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
#bash ../common/ag/registry.sh \
echo '{}' \
    | bash ../common/ag/registry0.sh \
    | bash ../common/ag/ps1.sh \
    | bash ../common/ag/web1.sh \
    | bash ../common/ag/ag1.sh \
    | bash ../common/ag/fed1.sh \
    | bash ../common/ag/configrGit1.sh \
    | bash ../common/ag/rconfigrGit1.sh \

# leaving an extra empty line to allow all other lines to end with \
