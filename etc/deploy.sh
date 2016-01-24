#!/bin/bash
#
# Here are examples of settings you might need to change on 
# a per-project basis. If so, create a file in your projects' root 
# folder called .deployrc. Project settings will override both 
# system & per-user settings.
# 
# If any value set here will override both global and per-user settings.

# The URL for this repo's hosting, with no trailing slash. For example, 
# if you use Github and your repo URL looks like https://github.com/EMRL/deploy
# your REPOHOST should be set to https://github.com/EMRL (with no trailling slash)
# REPOHOST=""

# A human readable project name
# PROJNAME="Best Webapp Ever"	

# A human readable client name
# PROJCLIENT="Client Name"

# Development project URL, without http://
# DEVURL="http://devurl.com/"

# Production, or "Live" project URL, without http://
# PRODURL="http://productionurl.com/"

# The exact name of the Bitbucket/Github repository
# REPO="name-of-repo"

# Configure your branches. In most cases the name will be master & production. If
# you are only using a master branch, leave production undefined.
MASTER="master"
PRODUCTION="production"

# If for some reason you'd like a default commit message. It will
# always be editable before finalizing commit.	
# COMMITMSG="This is a default commit message"

# The command to finalize deployment of your project(s)
DEPLOY="mina deploy"				

# Set the address and subject line of 
# TO="deploy@emrl.com"

# Disallow deployment; set to TRUE to enable. Double negative, it's tricky.
# DONOTDEPLOY="1"	

# Integration options.
# TASK="task"

# Slack Integration for this project
# POSTTOSLACK="TRUE"
# SLACKURL="https://hooks.slack.com/services/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"
