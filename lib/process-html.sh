#!/usr/bin/env bash
#
# process-html.sh
#
###############################################################################
# Filters through html templates to inject our project's variables
###############################################################################
trace "Loading html handling"

# Initialize variables 
read -r DEFAULTC PRIMARYC SUCCESSC INFOC WARNINGC DANGERC SMOOCHID COVER \
  SCANC <<< ""
echo "${DEFAULTC} ${PRIMARYC} ${SUCCESSC} ${INFOC} ${WARNINGC} ${DANGERC} 
  ${SMOOCHID} ${COVER} ${SCANC}" > /dev/null

function process_html() {
  # Clean out the stuff we don't need
  [[ -z "${DEVURL}" ]] && sed -i '/<strong>Staging URL:/d' "${htmlFile}"
  [[ -z "${PRODURL}" ]] && sed -i '/PRODURL/d' "${htmlFile}"
  [[ -z "${UPTIME}" ]] && sed -i '/UPTIME/d' "${htmlFile}"
  [[ -z "${LATENCY}" ]] && sed -i '/LATENCY/d' "${htmlFile}"  
  [[ -z "${SCAN_MSG}" ]] && sed -i '/SCAN_MSG/d' "${htmlFile}" 
  [[ -z "${PROJCLIENT}" ]] && sed -i 's/()//' "${htmlFile}"
  [[ -z "${CLIENTLOGO}" ]] && sed -i '/CLIENTLOGO/d' "${htmlFile}"
  [[ -z "${CLIENTCONTACT}" ]] && sed -i '/CLIENTCONTACT/d' "${htmlFile}"
  [[ -z "${notes}" ]] && sed -i '/NOTES/d' "${htmlFile}"
  [[ -z "${SMOOCHID}" ]] && sed -i '/SMOOCHID/d' "${htmlFile}"

  if [[ -z "${RESULT}" ]] || [[ "${RESULT}" == "0" ]] || [[ "${SIZE}" == "0" ]]; then
    sed -i '/BEGIN ANALYTICS/,/END ANALYTICS/d' "${htmlFile}"
    sed -i '/ANALYTICS/d' "${htmlFile}"
  fi

  # Get to work
  sed -i -e "s^{{VIEWPORT}}^${VIEWPORT}^g" \
    -e "s^{{NOW}}^${NOW}^g" \
    -e "s^{{DEV}}^${DEV}^g" \
    -e "s^{{LOGTITLE}}^${LOGTITLE}^g" \
    -e "s^{{USER}}^${USER}^g" \
    -e "s^{{PROJNAME}}^${PROJNAME}^g" \
    -e "s^{{PROJCLIENT}}^${PROJCLIENT}^g" \
    -e "s^{{CLIENTLOGO}}^${CLIENTLOGO}^g" \
    -e "s^{{DEVURL}}^${DEVURL}^g" \
    -e "s^{{PRODURL}}^${PRODURL}^g" \
    -e "s^{{COMMITURL}}^${COMMITURL}^g" \
    -e "s^{{EXITCODE}}^${EXITCODE}^g" \
    -e "s^{{COMMITHASH}}^${COMMITHASH}^g" \
    -e "s^{{NOTES}}^${notes}^g" \
    -e "s^{{USER}}^${USER}^g" \
    -e "s^{{LOGURL}}^${LOGURL}^g" \
    -e "s^{{REMOTEURL}}^${REMOTEURL}^g" \
    -e "s^{{VIEWPORTPRE}}^${VIEWPORTPRE}^g" \
    -e "s^{{PATHTOREPO}}^${WORKPATH}/${APP}^g" \
    -e "s^{{PROJNAME}}^${PROJNAME}^g" \
    -e "s^{{CLIENTCONTACT}}^${CLIENTCONTACT}^g" \
    -e "s^{{DEVURL}}^${DEVURL}^g" \
    -e "s^{{PRODURL}}^${PRODURL}^g" \
    -e "s^{{DEFAULT}}^${DEFAULTC}^g" \
    -e "s^{{PRIMARY}}^${PRIMARYC}^g" \
    -e "s^{{SUCCESS}}^${SUCCESSC}^g" \
    -e "s^{{INFO}}^${INFOC}^g" \
    -e "s^{{WARNING}}^${WARNINGC}^g" \
    -e "s^{{DANGER}}^${DANGERC}^g" \
    -e "s^{{SCAN}}^${SCANC}^g" \
    -e "s^{{SCAN_MSG}}^${SCAN_MSG}^g" \
    -e "s^{{SCAN_RESULT}}^${SCAN_RESULT}^g" \
    -e "s^{{SCAN_URL}}^${SCAN_URL}^g" \
    -e "s^{{SMOOCHID}}^${SMOOCHID}^g" \
    -e "s^{{GRAVATARURL}}^${REMOTEURL}\/${APP}\/avatar^g" \
    -e "s^{{DIGESTWRAP}}^${DIGESTWRAP}^g" \
    -e "s^{{GREETING}}^${GREETING}^g" \
    -e "s^{{REMOTEURL}}^${REMOTEURL}^g" \
    -e "s^{{ANALYTICSMSG}}^${ANALYTICSMSG}^g" \
    -e "s^{{STATURL}}^${REMOTEURL}\/${APP}\/stats^g" \
    -e "s^{{COVER}}^${COVER}^g" \
    -e "s^{{WEEKOF}}^${WEEKOF}^g" \
    -e "s^{{LASTMONTH}}^${LAST_MONTH}^g" \
    -e "s^{{UPTIME}}^${UPTIME}^g" \
    -e "s^{{LATENCY}}^${LATENCY}^g" \
    -e "s^{{GA_HITS}}^${GA_HITS}^g" \
    -e "s^{{GA_PERCENT}}^${GA_PERCENT}^g" \
    -e "s^{{GA_SEARCHES}}^${GA_SEARCHES}^g" \
    -e "s^{{GA_DURATION}}^${GA_DURATION}^g" \
    -e "s^{{GA_SOCIAL}}^${GA_SOCIAL}^g" \
    "${htmlFile}"        
}
