#!/bin/bash
helm install siteminderserver siteminder/server-components -n siteminder -f ps.yaml --version=1.0.3057
