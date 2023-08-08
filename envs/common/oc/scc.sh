cat <<EOF | kubectl apply -f - 
apiVersion: security.openshift.io/v1
kind: SecurityContextConstraints
metadata:
  name: nginx-ingress-scc
 
priority: null
users:
- system:serviceaccount:ingress:ingress-nginx-admission
- system:serviceaccount:ingress:ingress-nginx
groups: []
 
allowHostDirVolumePlugin: false
allowHostIPC: false
allowHostNetwork: false
allowHostPID: false
allowHostPorts: false
allowPrivilegeEscalation: true
allowPrivilegedContainer: false
allowedCapabilities: null
defaultAddCapabilities:
- NET_BIND_SERVICE
readOnlyRootFilesystem: false
requiredDropCapabilities:
- ALL
runAsUser:
  type: MustRunAs
  uid: 101
fsGroup:
  type: MustRunAs
seLinuxContext:
  type: MustRunAs
supplementalGroups:
  type: MustRunAs
volumes:
- secret
EOF
