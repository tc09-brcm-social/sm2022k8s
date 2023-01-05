#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi

#
## dossprepo
#
dossprepo() {
    if [[ -z "$(repoexist "$SSPREPO")" ]] ; then
        bash "${MYPATH}/../base/ssprepo.sh"
    else
        >&2 echo $SSPREPO exists
    fi
    }

#
## dodockersecret
#
dodockersecret() {
    local _secret
    local _server
    local _name
    local _password
    local _email

    if [[ -z "$SSPDOCKERSECRET" ]] ; then
	>&2 echo Using default official docker registry
	_secret="ssp-registrypullsecret"
        _server="https://securityservices.packages.broadcom.com/"
	_name="$SSPID"
	_password="$SSPPWD"
	_email="$SSPEMAIL"
    else
	>&2 echo Using private docker registry
        _secret="$SSPDOCKERSECRET"
        _server="$SSPSERVER"
        _name="$SSPUSERNAME"
        _password="$SSPPASSWORD"
        _email="$SSPEMAIL"
    fi
    doPullSecret "$_secret" \
	"$_server" "$_name" "$_password" \
	"$SSP"
    }

#
## dosspinfrahelm
#
dosspinfrahelm() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    dodockersecret
    if [[ -z "$(relexist "$SSP" "$SSPINFRAREL")" ]] ; then
        cat "$SSPINFRAVALUES" \
	     | if [[ -z "$SSPINFRARTVALUES" ]] ; then cat - ; else \
		  bash "$SSPINFRARTVALUES"
	      fi \
             | helm "$_action" "$SSPINFRAREL" -n "$SSP" "$SSPREPO/ssp-infra" \
                   -f - \
                   $SSPVER $_option > "$_output"
    fi
    }

#
## dossphelm
#
dossphelm() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    createtls "${SSP}" "$SSPTLS" "$SSPPEM" "$SSPKEY"
    if [[ -z "$(relexist "$SSP" "$SSPRELEASE")" ]] ; then
        cat "$SSPVALUES" \
             | helm $_action "$SSPRELEASE" -n "$SSP" "$SSPREPO/ssp" \
                   -f - \
                   $SSPVER $_option > "$_output"
    fi
    }

#
## Starts Here
#

dossprepo
createns "$SSP"
#dosspinfrahelm template "$SSPINFRAREL.$SSP.$$".yaml
dosspinfrahelm install "$SSPINFRAREL.$SSP.$$".debug "--debug"
kubectl wait jobs.batch -n "$SSP" \
    --selector "app.kubernetes.io/name=$SSP-infra-create-db-job" \
    --for 'condition=complete' --timeout '5m'
dossphelm "upgrade --install" "$SSPRELEASE.$SSP.$$".debug "--debug"
