#!/bin/bash

APP="APP_NAME_HERE"
NEW_RELIC_API_KEY="NEW_RELIC_API_KEY_HERE"
NEW_RELIC_API_URL="https://api.newrelic.com/v2"
NEW_RELIC_API_NAME="alert_policies"
DATE=`date +%Y-%m-%d`
LIST_NAME="app_id_list"
NAME_PREFIX="${DATE}-${APP}_"
SLACK_HOOK="SLACK_HOOK_HERE"
SLACK_PREFIX="NewRelic"

function send_slack  {
	json="{\"text\": \"${SLACK_PREFIX} - $1\"}"
	curl -s -X POST  --data-urlencode "payload=$json" ${SLACK_HOOK}
}

echo Starting Policy Update for ${APP}
send_slack "${DATE} Starting Policy Update for ${APP}"

#####
echo "*****"
echo - Current Status
echo -- Loading Current Policy

new_relic_api_id=`curl -Ss ${NEW_RELIC_API_URL}/${NEW_RELIC_API_NAME}.json \
                -H 'X-Api-Key:'${NEW_RELIC_API_KEY} \
                -G -d 'filter[name]='${APP} | \
                jq '.alert_policies[].id'`
{
    curl -Ss ${NEW_RELIC_API_URL}/${NEW_RELIC_API_NAME}/${new_relic_api_id}.json \
         -H 'X-Api-Key:'${NEW_RELIC_API_KEY} \
         -G -d 'filter[name]='${APP} | \
         jq '.' >${NEW_RELIC_API_NAME}.json
} &> /dev/null

policy_name=`jq '.alert_policy.name' ${NEW_RELIC_API_NAME}.json | sed 's/"//g'`
echo -- Name: ${policy_name}
send_slack "Policy Name: ${policy_name}"

#####
echo "*****"
echo - Getting App List
{
    curl -Ss ${NEW_RELIC_API_URL}/applications.json \
    -H 'X-Api-Key:'${NEW_RELIC_API_KEY} \
    -G -d 'filter[name]='${APP} | \
    jq '.applications | .[].id' >${LIST_NAME}
} &> /dev/null

#####
echo -- Apps on This Update
app_list=`curl -Ss ${NEW_RELIC_API_URL}/applications.json \
    -H 'X-Api-Key:'${NEW_RELIC_API_KEY} \
    -G -d 'filter[name]='${APP} | \
    jq -r '.applications | .[].name'`
echo ${app_list}
send_slack "App List: ${app_list}"

echo "*****"

#####
echo - New Status
echo -- Converting App List to JSON
> ${NAME_PREFIX}${LIST_NAME}.json

cat ${LIST_NAME} | \
awk ' BEGIN { ORS = ""; print "["; } { print "\/\@"$0"\/\@"; } END { print "]"; }' | sed "s^\"^\\\\\"^g;s^\/\@\/\@^\", \"^g;s^\/\@^\"^g" \
>> ${NAME_PREFIX}${LIST_NAME}.json

#####
echo -- Updating Policy App List
list_json=`cat "${DATE}-${APP}_${LIST_NAME}.json" | sed 's/"//g'`
jq '.alert_policy.links.applications |= '"${list_json}" \
${NEW_RELIC_API_NAME}.json>${NAME_PREFIX}${NEW_RELIC_API_NAME}.json

echo -- Uploading Policy to NewRelic
send_slack "Updating NewRelic"

policy_json=`cat ${NAME_PREFIX}${NEW_RELIC_API_NAME}.json`
{
    cu
    curl -X PUT ${NEW_RELIC_API_URL}/${NEW_RELIC_API_NAME}/${new_relic_api_id}.json \
         -H 'X-Api-Key:'${NEW_RELIC_API_KEY} -i \
         -H 'Content-Type: application/json' \
         -d "${policy_json}"
} &> /dev/null

rm ${NEW_RELIC_API_NAME}.json
rm ${NAME_PREFIX}${LIST_NAME}.json
rm ${LIST_NAME}

echo "*****"