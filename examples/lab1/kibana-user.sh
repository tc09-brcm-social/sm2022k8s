#!/bin/bash
KIBANADEFUSERSECRET="kibana-user"
LOGGING="logging"
KIBANADEFUSERNAME="kibana-admin"
KIBANADEFUSERPWD="P@ssw0rd1"
                kubectl create secret generic "$KIBANADEFUSERSECRET"  -n "$LOGGING" \
                    --from-literal roles=superuser \
                    --from-literal username="$KIBANADEFUSERNAME" \
                    --from-literal password="$KIBANADEFUSERPWD"

