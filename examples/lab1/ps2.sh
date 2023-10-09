#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
echo '{}' \
    | bash sc/registry0.sh \
    | bash sc/baseCompat.sh \
    | bash sc/pods1.sh \
    | bash sc/pssNP.sh \
    | bash sc/adminui.sh \
    | bash sc/pstore2.sh \
    | bash sc/stores2.sh \
    | bash sc/configrGit1.sh \
    | bash sc/rconfigrGit1.sh \

# leave an empty line to allow trailing \ to work
