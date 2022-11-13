# examples/3rdimages
Third-party docker images used by SiteMinder Container Form Factor

This example depends on the registry and default setting to cacluate
the values.yaml. It also uses the current helm chart configuration.
If necessary, define/re-define the helm charts using
"helm repo add" first. Then

The current attempt that uses images: to identify the docker images
is actually not complete. For example, the two below were missed

prometheus missed:
            - --prometheus-config-reloader=quay.io/prometheus-operator/prometheus-config-reloader:v0.53.1
            - --thanos-default-base-image=quay.io/thanos/thanos:v0.24.0
manual fixes are in the images.sh

bash make.sh # to proceed
