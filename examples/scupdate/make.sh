#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
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
YAML="$$.yaml"
bash ../../envs/common/sc/rtvalues.sh | \
    bash "$MYPATH/$UPDATE" > "$YAML"
if [[ -s "$YAML" ]]; then
    cat "$YAML" | \
        bash ../../op/sc/update.sh - "update server component using $UPDATE script"
else
    >&2 echo "empty yaml output, server component update skipped"
fi
