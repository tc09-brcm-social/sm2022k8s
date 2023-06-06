#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/sc/values.sh \
    | bash ../common/sc/registry.sh \
    | bash ../common/sc/baseCompat.sh \
    | bash ../common/sc/pstore2.sh \
    | bash ../common/sc/stores2.sh \
    | bash ../common/sc/pscNP.sh \
    | bash ../common/sc/configrGit1.sh \
    | bash ../common/sc/rconfigrGit1.sh \
    | bash ../common/sc/pspod1.sh \
    | bash ../common/sc/adminpod1a.sh \
    | bash ../common/sc/ingress1.sh \
    | bash ../common/sc/enfdefault.sh

