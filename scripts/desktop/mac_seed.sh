#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Usage: ./mac_seed.sh COUNT PERCENTAGE STATE"
  exit 1
else
  desktop_count=$1
  config_percentage=$2
  state=$3

  today=$(date --rfc-3339=seconds  -d "today" | sed 's/ /T/' | sed 's/\+.*/Z/')
  token='DontTryThisAtHome='

  # Assumptions: There is a "mac_pass.json" and a "mac_fail.json" that capture a CCR witht he associated state
  file="mac_$state.json"
  desktop_os='mac'

  /root/ccr-data/scripts/ccr-seed.sh $desktop_count $config_percentage $yesterday $file $desktop_os $token
fi
