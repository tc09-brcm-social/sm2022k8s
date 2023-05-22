#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
# resetroot
# resetbase
LINES="$(grep '^[^# ]*=' env.shlib | sed 's/=.*$//')"
for i in $LINES ; do
    if [[ "$i" == "CLOUD" ]] ; then
        envroot "$i" "$(eval 'echo $'$i)"
    elif [[ "$i" == "K8SNAME" ]] ; then
        envroot "$i" "$(eval 'echo $'$i)"
    elif [[ "$i" == "K8SVER" ]] ; then
        envroot "$i" "$(eval 'echo $'$i)"
    else
        envbase "$i" "$(eval 'echo $'$i)"
    fi
done
SMMAINTVALUES="$MYPATH/smmaint-values.yaml"
envbase SMMAINTVALUES "$SMMAINTVALUES"
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
if [[ ! -z "$(relexist "$PSNS" "$SMMAINTREL" )" ]] ; then
    bash "$MYPATH/../../envs/common/smmaint/rtvalues.sh" | bash "$OP" > "$SMMAINTVALUES"
elif [[ -z "$(relexist "$PSNS" "$PSREL")" ]] ; then
    bash "$MYPATH/../../envs/common/sc/values.sh" | bash "$OP" > "$SMMAINTVALUES"
else
    bash "$MYPATH/../../envs/common/sc/rtvalues.sh" | bash "$OP" > "$SMMAINTVALUES"
fi
helm upgrade --install "$SMMAINTREL" "$SMREPO/siteminder-maintenance" \
     -f "$SMMAINTVALUES" -n "$PSNS" "$SMVER" \
     --history-max 0 \
     --description="$OPDESC" --debug > "$SMMAINTVALUES.debug"
