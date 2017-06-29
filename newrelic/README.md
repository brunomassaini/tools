# NewRelic Scripts

## policy_auto_update_applications_list.sh

Script that dumps current policy configured on NewRelic that mets criteria, get all apps that met same criteria and assign all those apps to that policy

``` bash
APP="APP_NAME_HERE"
NEW_RELIC_API_KEY="NEW_RELIC_API_KEY_HERE"
NEW_RELIC_API_URL="https://api.newrelic.com/v2"
NEW_RELIC_API_NAME="alert_policies"
DATE=`date +%Y-%m-%d`
LIST_NAME="app_id_list"
NAME_PREFIX="${DATE}-${APP}_"
SLACK_HOOK="SLACK_HOOK_HERE"
SLACK_PREFIX="NewRelic"
```

`APP` - Application name (policy should contain app name)
Example:
NewRelic app name: foo-bar
NewRelic policy name: Foo Policy
Script variable: `APP="foo"`

`NEW_RELIC_API_KEY` - NewRelic API Key (not license key)
`NEW_RELIC_API_NAME` - Check https://api.newrelic.com/
`SLACK_HOOK` - Slack webhook to which notifications will be sent