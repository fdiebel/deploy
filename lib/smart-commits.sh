#!/bin/bash
#
# smrtCommit()
#
# Tries to create "Smart Commit" messages based on parsing
# output from wp-cli.
trace "Loading smart commit functions"

# Constructing smart *cough* commit messages
function smrtCommit() {
	if [[ "${SMARTCOMMIT}" == "TRUE" ]]; then
		trace "Building commit message"
		# Checks for the existence of a successful plugin upgrade, using grep, and if 
		# we find updates, grab the relevant line of text from the logs
		# Looks like this changed somehow, new version of wp-cli maybe?
		PCA=$(grep '\<Success: Updated' "${logFile}" | grep 'plugins')
		if [[ -z "${PCA}" ]]; then
			trace "No plugin updates"
		else
			# How many plugins have we updated? First, strip out the Success:
			PCB=$(echo "${PCA}" | sed 's/^.*\(Updated.*\)/\1/g')
			# Strips the last period, makes my head hurt.
			# PCC=${PCB%?}; PCD=$(echo $PCB | cut -c 1-$(expr `echo "$PCC" | wc -c` - 2))
			PCC=$(echo "${PCB}" | tr -d .)
			# Get this thing ready; first remove the leading spaces 
			awk '{print $1, $2}' "${wpFile}" > "${trshFile}" && mv "${trshFile}" "${wpFile}";
			# Add commas between the plugins with this
			sed ':a;N;$!ba;s/\n/, /g' "${wpFile}" > "${trshFile}" && mv "${trshFile}" "${wpFile}";
			# Replace current commit message with plugin upgrade info 
			PLUGINS=$(<"${wpFile}")
			COMMITMSG="$PCC ($PLUGINS)"
		fi

		# Is this an ACF-only update?
		if [[ -n "${ACFFILE}" ]] && [[ -z "${PCA}" ]]; then
			PCC="Updated 1 of 1 plugin"
			PLUGINS="advanced-custom-fields-pro"
			COMMITMSG="$PCC ($PLUGINS)"
		fi

		# So what about a Wordpress core upgrade?
		if [[ $UPDCORE == "1" ]]; then
			if [[ -z "$PCC" ]]; then 
				COMMITMSG="Updated system (wp-core $COREUPD)"
			else
				COMMITMSG="$PCC ($PLUGINS) and system (wp-core $COREUPD)"
			fi
		else			
			trace "No system updates"
		fi

		# Output the contents of $COMMITMSG
		trace "Auto-generated commit message: $COMMITMSG"
	fi
}
