#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
echo '{}' \
    | bash ag/register0.sh \
    | bash ag/base.sh \
    | bash ag/ps1.sh \
    | bash ag/ag1.sh \
    | bash ag/fed1.sh \
    | bash ag/ingress.sh \
    | bash ag/configrGit1.sh \
    | bash ag/rconfigrGit1.sh \

# leave an empty line to allow trailing \ to work
