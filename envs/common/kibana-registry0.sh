#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
    if [[ -z "$ELASTICREGISTRYBASE" ]] ; then cat - ; else \
          yq -Y --arg r "$ELASTICREGISTRYBASE" \
              ' .image = ($r + "/kibana")
              '
      fi \
    | if [[ -z "$ELASTICDOCKERSECRET" ]] ; then cat - ; else \
          yq -Y --arg s "$ELASTICDOCKERSECRET" \
              ' .imagePullSecrets[0].name = $s
              '
      fi
# .image
# .imagePullSecrets[]
# https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret
