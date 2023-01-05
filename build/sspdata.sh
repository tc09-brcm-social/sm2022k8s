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
## dosspdatahelm
#
dosspdatahelm() {
    local _action="$1"
    local _output="$2"
    local _option="$3"

    dodockersecret
    if [[ -z "$(relexist "$SSP" "$SSPDATAREL")" ]] ; then
        cat "$SSPDATAVALUES" \
             | helm "$_action" "$SSPDATAREL" -n "$SSP" "$SSPREPO/ssp-data" \
                   -f - \
                   $SSPDATAVER $_option > "$_output"
    fi
    }


#
## Starts Here
#

dossprepo
createns "$SSP"
dosspdatahelm install "$SSPDATAREL.$SSP.$$".debug "--debug"
