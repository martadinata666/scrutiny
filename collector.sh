#!/bin/bash 
/scrutiny/collector/scrutiny-collector-metrics-linux-${ARCH} run --api-endpoint ${SCRUTINY_API_URL} >/proc/1/fd/1 2>/proc/1/fd/2
