#!/bin/bash
cron -f
 /home/$CONTAINERUSER/scrutiny/bin/scrutiny-web-linux-amd64 start --config /home/$CONTAINERUSER/scrutiny/config/scrutiny.yaml
