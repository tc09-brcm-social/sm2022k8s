#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi

if [[ -z "$(repoexist "$SMREPO")" ]] ; then
    bash "${MYPATH}/../base/smrepo.sh"
else
    >&2 echo $SMREPO exists
fi
cd "${MYPATH}"
. ./env.shlib

#
## psrelpreq
#
psrelpreq() {
    local _ver="$1"
    local _newver="$2"

    if [[ -z "$_newver" ]] ; then
	>&2 echo upgrade to version not specified
	echo 1
    else
        bash "${MYPATH}/ps/values.sh"  > "$PSVALUES"
	helm search repo "$SMREPO" --versions -o json \
	    | jq '[.[] | select(.name == "'$SMREPO/server-components'")]' \
	    > "$HELMSEARCH"
	tag="$(jq -r '.[] | select(.version == "'$_ver'") | .app_version' "$HELMSEARCH")"
	newtag="$(jq -r '.[] | select(.version == "'$_newver'") | .app_version' "$HELMSEARCH")"
	envbase SMTAG "$tag"
	envbase SMNEWTAG "$newtag"
	tag0="$(yq -r '.policyServer.tag' "$PSVALUES")"
	if [[ "$tag" = "$tag0" ]] ; then
	    echo 0
	else
	    >&2 echo runtime version $tag0 does not match with environment version $tag
	    echo 1
	fi
    fi
    }

#
## Start Here
#

createns "$PSNS"

#
## Upgrade SiteMinder Server Components chart
#
if [[ -z "$(relexist "$PSNS" "$PSREL")" ]] ; then
    >&2 echo SiteMinder Server Component release $PSREL is not installed in namespace $PSNS
#    helm install "$PSREL" -n ${PSNS} \
#        $SMREPO/server-components $SMVER -f "$PSVALUES" \
#	--debug > "$PSREL.$PSNS.$$.debug"
else
    PSVALUES="$MYPATH/ps.$$.values.yaml"
    HELMSEARCH="$MYPATH/ps.$SMREPO.$$.json"
    if [ "$(psrelpreq "$(echo "$SMVER" | cut -f2 -d=)" \
	    "$(echo "$SMVERNEW" | cut -f2 -d=)")" -eq 0 ] ; then
        ADMINENABLED="$(yq -r '.admin.enabled' "$PSVALUES")"
        ADMINS="$(yq -r '.admin.replicas' "$PSVALUES")"
	ADMINR="$(bash "$MYPATH/../op/admin/pods.sh" | jq 'length')"
	if [[ "$ADMINENABLED" = "true" ]] ; then
	    if (( $ADMINR < 2 )) ; then
	        bash "$MYPATH/../op/admin/scale.sh" 1
	    fi
	    if (( $ADMINS < 2 )) ; then
	        ADMINS=2
	    fi
	fi
	echo $ADMINENABLED $ADMINS $ADMINR
	envbase ADMINS "$ADMINS"
	cat "$PSVALUES" | bash "$MYPATH/../envs/common/ps/upgradeps1.sh" > "$PSVALUES".0
	bash "$MYPATH/../envs/common/ps/newvalues.sh" > "$PSVALUES".1
	helm upgrade "$PSREL" "$SMREPO/server-components" -n "$PSNS" \
	    -f "$PSVALUES".1 -f "$PSVALUES".0 $SMVERNEW \
	    --description="upgrade policy server pod to $SMVERNEW" \
	    --timeout=30m --wait --debug > "$PSVALUES".debug
    else
	>&2 echo pre-req check failed
    fi
#    >&2 echo release $PSREL exists, attempt to upgrade
#    helm upgrade --install "$PSREL" -n ${PSNS} \
#        $SMREPO/server-components $SMVER -f "$PSVALUES" \
#        --debug > "$PSREL.$PSNS.$$.debug"
fi
