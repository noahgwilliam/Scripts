#!/bin/bash

ENVIRONMENT=$1
EXECUTE=$2

env_tag() {
# This will do nothing if a tag is attached to the log-group with the respective Environment parameter, if not found then an Environment tag is attached (or replaced).
GROUP_LIST=$(aws logs describe-log-groups | jq -r ".logGroups[].logGroupName" | grep -E -i ${ENVIRONMENT})
for GROUP in $GROUP_LIST; do 
    if aws logs list-tags-log-group --log-group-name ${GROUP} | grep -i ${ENVIRONMENT}; then 
        echo "Tag: ${ENVIRONMENT} found in ${GROUP}";
    else
        if [ "$EXECUTE" == "yes" ]; then
            aws logs tag-log-group --log-group-name ${GROUP} --tags Environment=${ENVIRONMENT};
            echo "Tag: ${ENVIRONMENT} was NOT found in ${GROUP}, TAG CREATED";
        else 
            printf "aws logs tag-log-group --log-group-name ${GROUP} --tags Environment=${ENVIRONMENT}\n";
        fi;
    fi;
done
}
env_tag
