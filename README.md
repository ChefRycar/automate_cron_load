# automate_cron_load

Initial Commit. Full README to come, but most information can be found in the ccr_seed.sh script.

The script assumes you have json files containing the sample CCR you'd like to use. You can generate one by adding the following to a client.rb:

```
Chef::Config[:data_collector][:output_locations] = { files:  [ "/PATH/TO/FILE.JSON" ] }
```