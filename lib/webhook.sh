#!/usr/bin/env bash
#
# webhook.sh
#
###############################################################################
# Webhook POST functionality
###############################################################################

function post_webhook {
  if [[ -n "${POSTURL}" ]]; then
    # Create payload for digests
    if [[ "${DIGEST}" == "1" ]] && [[ -n "${GREETING}" ]]; then
      message_state="DIGEST"
      payload="*${PROJNAME}* updates for the week of ${WEEKOF} (<${DIGESTURL})"               
      # Send it
      "${curl_cmd}" -X POST --data "payload={\"text\": \"${payload}\"}" "${POSTURL}" > /dev/null 2>&1; error_status
    fi

    # Create payload for reports
    if [[ "${REPORT}" == "1" ]]; then
      payload="Monthly report for *${PROJNAME}* created (<${REPORTURL})" 
      "${curl_cmd}" -X POST --data "payload={\"text\": \"${payload}\"}" "${POSTURL}" > /dev/null 2>&1; error_status              
    fi
  fi
}

# Webhook configuration test
function test_webhook {
  console "Testing POST integration..."
  echo "${POSTURL}"
  if [[ -z "${POSTURL}" ]]; then
    warning "No webhook URL found."; empty_line
    clean_up; exit 1
  else
    "${curl_cmd}" -X POST --data "payload={\"text\": \"Testing POST integration of ${APP} from stir ${VERSION}\nhttps://github.com/EMRL/stir\"}" "${POSTURL}"
    empty_line
  fi
}
