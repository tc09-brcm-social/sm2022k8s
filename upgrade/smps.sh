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
        bash "${MYPATH}/../envs/common/sc/rtvalues.sh"  > "$PSVALUES"
	helm search repo "$SMREPO" --versions -o json \
	    | jq '[.[] | select(.name == "'$SMREPO/server-components'")]' \
	    > "$HELMSEARCH"
	tag="$(jq -r '.[] | select(.version == "'$_ver'") | .app_version' "$HELMSEARCH")"
	newtag="$(jq -r '.[] | select(.version == "'$_newver'") | .app_version' "$HELMSEARCH")"
	tag0="$(yq -r '.policyServer.tag' "$PSVALUES")"
	if [[ "$(yq -r '.policyServer.replicas' "$PSVALUES")" < "$PSMIN" ]] ; then
	    >&2 echo running policy server pod replica is insufficient to continue, expect $PSMIN minimally
	    echo 1
	elif [[ "$tag" = "$tag0" ]] ; then
	    envbase SMTAG "$tag"
	    envbase SMNEWTAG "$newtag"
	    >&2 yq '.policyServer.rollingUpdate' "$PSVALUES"
	    echo 0
	else
	    >&2 echo runtime version $tag0 does not match with environment version $tag
	    echo 1
	fi
    fi
    }

#
## uppspod
#
uppspod() {
    bash ../envs/common/sc/newvalues.sh > "$PSVALUES".1
    cat "$PSVALUES" | \
	bash ../envs/common/sc/upgradeps1.sh  > "$PSVALUES".0
    helm upgrade "$PSREL" "$SMREPO/server-components" -n "$PSNS" \
        -f "$PSVALUES".1 -f "$PSVALUES".0 $SMVERNEW \
        --description="upgrade policy server pod to $SMVERNEW" \
        --timeout=30m --wait --debug > "$PSVALUES".debug
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
    exit 1
fi
if [[ "$(bash "$MYPATH/../envs/common/sc/rtvalues.sh" | yq -r '.policyServer.enabled')" != \
    "true" ]] ; then
    >&2 echo SiteMinder Policy Server Pod is not enabled, upgrade skipped.
    exit
fi
PSVALUES="$MYPATH/ps.$$.values.yaml"
HELMSEARCH="$MYPATH/ps.$SMREPO.$$.json"
if [[ "$(psrelpreq "$(echo "$SMVER" | cut -d= -f2)" "$(echo "$SMVERNEW" | cut -d= -f2)")" == 0 ]] ; then
  >&2 echo to upgrade
  uppspod
else
  >&2 echo pre-requsites are not met, quit upgrading
fi

