#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
    bash ../../envs/common/sc/configrGit1.sh \
    | bash ../../envs/common/sc/rconfigrGit1.sh \

