#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
    bash ../../envs/common/sc/pspod0.sh \
    | bash ../../envs/common/sc/adminpod1.sh \

