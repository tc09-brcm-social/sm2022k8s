#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
# GITREPOBASE="git-codecommit.us-west-1.amazonaws.com/v1/repos/sm001.git"
GITREPO="https://${GITID}:${GITPAT}@${GITREPOBASE}"
git clone -b "$GITFROM" "$GITREPO" "cr${GITTO}"
