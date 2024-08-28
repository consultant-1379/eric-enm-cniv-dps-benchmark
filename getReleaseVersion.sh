#!/bin/bash

echo -n "  - cbos-newest-version: " >> common-properties.yaml
curl https://arm.seli.gic.ericsson.se/artifactory/docker-v2-global-local/proj-ldc/common_base_os_release/sles/  \
  | sed 's/<\/*[^>]*>//g' \
  | sed '/SNAPSHOT/d' \
  | grep '^[0-9]' \
  | sed -E 's|(.*\/) +([0-9]{2})-([A-Z][a-z]{2})-([0-9]{4}) ([0-9]{2}:[0-9]{2})    -|\1 \2 \3 \4 \5|' \
  | sort -k 4n -k 3M -k 2n -k 5 \
  | tail -1 \
  | grep -o '^.*/' \
  | sed 's|/||' >> common-properties.yaml