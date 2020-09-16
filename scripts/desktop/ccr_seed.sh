#!/bin/bash

if [ $# -ne 7 ]; then
  echo "Usage: ./ccr-seed.sh COUNT PERCENTAGE DATE FILE OS TOKEN AUTOMATE_URL"
  exit 1
else
  desktop_count=$1
  config_percentage=$2
  today=$3
  file=$4
  desktop_os=$5
  ingest_token=$6
  automate_url=$7

  # Sample Variable Values
  # desktop_count=1000
  # config_percentage=80
  # today=$(date --rfc-3339=seconds  -d "today" | sed 's/ /T/' | sed 's/\+.*/Z/')
  # file='windows_pass.json'
  # desktop_os='windows'
  # ingest_token='N1c3TrY'
  # automate_url='https://my.automate.server/'
  
  # Informational counters used in the run summary
  desktop_missing="0"
  desktop_confirm="0"

  for i in $( seq 1 $desktop_count );do

    # Assign a random number from 1 to 100
    rng_seed=`shuf -i 1-100 -n 1`

    # Skip this server if RNG is greater than our desired percentage
    if [ $rng_seed -gt $config_percentage ]; then
      echo "Skipping $desktop_os-$i"
      ((desktop_missing++))
    # Otherwise, load up a CCR
    else
      echo "Check-in for $desktop_os-$i"
      ((desktop_confirm++))

      # Assumption: There is a 'uuids' file for each target platform
      # The desktop count must be below the number of uuids in the seed file
      # See uuidgen.sh for more info

      # Create variables to help pull an associated UUID for our node
      sedhelper=$i"p"
      uuidhelper=$desktop_os"uuids"

      # Read our sample CCR json...
      cat /root/ccr-data/$file | \

      # Set arguments via jq for:
      # Date of the CCR
      jq --arg rfc_time "$today" \
      # Node Name
      --arg node_name "$desktop_os-$i" \
      # Node UUID (must be the same from run to run)
      --arg node_uuid `sed -n $sedhelper /root/ccr-data/$uuidhelper` \
      # Run UUID (unique for each run)
      --arg run_uuid $(uuidgen) \
      # Replace the appropriate values in our CCR JSON
      '.start_time = $rfc_time | .end_time = $rfc_time | .node_name = $node_name | .id = $run_uuid | .run_id = $run_uuid | .entity_uuid = $node_uuid' | \
      # API call to send data to Chef Automate
      curl -H "api-token: $ingest_token" -X POST "$automate_url/data-collector/v0" -H "Content-Type: application/json" -d @-
    fi

  done

  echo "Checked In: $desktop_confirm"
  echo "Missing: $desktop_missing"
fi
