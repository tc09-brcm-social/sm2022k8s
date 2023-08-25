kubectl get pods --all-namespaces | awk '{print $3, $4, $1, $2}'
