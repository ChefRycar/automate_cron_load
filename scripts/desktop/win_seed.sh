if [ $# -ne 3 ]; then
  echo "Usage: ./win_seed.sh COUNT PERCENTAGE STATE"
  exit 1
else
  desktop_count=$1
  config_percentage=$2
  state=$3

  today=$(date --rfc-3339=seconds  -d "today" | sed 's/ /T/' | sed 's/\+.*/Z/')
  token='DontTryThisAtHome='
    # Assumptions: There is a "windows_pass.json" and a "windows_fail.json" that capture a CCR witht he associated state
  file="windows_$state.json"
  desktop_os='windows'

  shell_command="/root/ccr-data/scripts/ccr-seed.sh $desktop_count $config_percentage $today $file $desktop_os $token"
  echo "Running $shell_command ..."
  $shell_command
fi