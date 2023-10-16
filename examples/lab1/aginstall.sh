#!/bin/bash
helm install siteminderserver siteminder/access-gateway -n siteminderag -f ag1.yaml --version=1.0.3057
