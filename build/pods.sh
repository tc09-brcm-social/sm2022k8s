kubectl get pods --all-namespaces | awk '{print $3, $4, $2}'
