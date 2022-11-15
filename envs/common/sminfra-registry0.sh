#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
    yq -Y --arg u "$SMDOCKERID" --arg p "$SMDOCKERPWD" \
          --arg r "$SMDOCKERURL" --arg s "$SMDOCKERREPOBASE" \
        '.global.registry.credentials.username = $u
        | .global.registry.credentials.password = $p
        | .global.registry.url = $r
	' \
    | if [[ -z "$PROADPREGISTRYBASE" ]] ; then cat - ; else \
          yq -Y --arg s "$PROADPREGISTRYBASE" \
	    ' ."prometheus-adapter".image.repository = ($s + "/prometheus-adapter")
	    '
      fi \
    | if [[ -z "$PROADPDOCKERSECRET" ]] ; then cat - ; else \
          yq -Y --arg s "$PROADPDOCKERSECRET" \
              ' ."prometheus-adapter".image.pullSecrets[0] = $s
              '
      fi \
    | if [[ -z "$SMINFRAREGISTRYBASE" ]] ; then cat - ; else \
          yq -Y --arg s "$SMINFRAREGISTRYBASE" \
	    ' ."fluent-bit".image.repository = ($s + "/fluent-bit")
	    | ."fluent-bit".testFramework.image.repository = ($s + "/busybox")
	    '
      fi \
    | if [[ -z "$SMINFRADOCKERSECRET" ]] ; then cat - ; else \
          yq -Y --arg s "$SMINFRADOCKERSECRET" \
              ' ."fluent-bit".imagePullSecrets[0].name = $s
              '
      fi
