#!/bin/bash
helm upgrade siteminderserver siteminder/server-components -n siteminder -f ps.yaml
