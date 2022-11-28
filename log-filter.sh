#!/bin/bash

# Description: SNS email message can be too long if time goes above 15 minutes

aws logs filter-log-events --log-group-name CloudTrail/<account number> \
    --start-time $(date -d "-15 minutes" +%s000)  \
    --query 'events[].message' \
    --output text |\
    jq ' . | select(.errorCode != null)' | grep -e eventID -e errorCode -e errorMessage |tee errors.txt
