#!/usr/bin/env bash
#
# doinst.sh
#
###############################################################################
# Installs and configures deploy 
#
# https://github.com/EMRL/deploy
###############################################################################

# Set mode
set -uo pipefail

# Initialize variables 
read -r OS VER EXITCODE dependencies option message fg_green fg_red reset \
  YES NO NOT i k <<< ""
echo "${OS} ${VER} ${EXITCODE} ${dependencies} ${option} ${message} ${fg_green} 
  ${fg_red} ${reset} ${YES} ${NO} ${NOT} ${i} ${k}" > /dev/null

# No root, no fun
if [[ "${EUID}" -ne 0 ]]; then
  echo "You must have root access to install - try 'sudo install/doinst.sh'" 2>&1
  exit 1
fi

function check_os() {
  # Try to discover the OS flavor 
  if [[ -f /etc/os-release ]]; then
    # freedesktop.org and systemd 
    # shellcheck disable=SC1091
    . /etc/os-release
    OS="${NAME}"
    VER="${VERSION_ID}"
  elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS="$(lsb_release -si)"
    VER="$(lsb_release -sr)"
  elif [[ -f /etc/lsb-release ]]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    # shellcheck disable=SC1091
    . /etc/lsb-release
    OS="${DISTRIB_ID}"
    VER="${DISTRIB_RELEASE}"
  elif [[ -f /etc/debian_version ]]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER="$(cat /etc/debian_version)"
  elif [[ -f /etc/SuSe-release ]]; then
    # Older SuSE/etc.
    ...
  elif [[ -f /etc/redhat-release ]]; then
    # Older Red Hat, CentOS, etc.
    ...
  else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS="$(uname -s)"
    VER="$(uname -r)"
  fi
}

function check_program() {
  printf "%-40s" "Checking for ${1}..."; read -p "" -t 0.03
  # There's potential for non-global stuff to fail this check so here's a
  # fairly kludgey way to hopefully allow those to pass
  if [[ "${1}" =~ ^(wp|grunt|npm)$ ]]; then
    command -v $(type -p "${1}") >/dev/null 2>&1 && echo "${YES}" || { echo "${NOT}"; message+="${1} "; }
  else
    command -v "${1}" >/dev/null 2>&1 && echo "${YES}" || { echo "${NOT}"; message+="${1} "; }
  fi
}

function error_check() {
  EXITCODE=$?; 
  if [[ "${EXITCODE}" != "0" ]]; then 
    echo "Error ${EXITCODE}: deploy not installed."
    exit "${EXITCODE}"
  fi
}

echo; check_os
if [[ -n "${OS}" ]] && [[ -n "${VER}" ]]; then
  echo "=> Checking operating system: "; sleep .3
  echo "${OS} ${VER}"; sleep 1
else
  # No values, crash out for now
  exit 1
fi

# Declare dependencies
dependencies=(awk cal cat curl echo eval git grep pkill printf read sed sendmail sleep tee tput)

# Declare optional stuff
options=(gitchart grunt npm scp ssh sshpass wget wkhtmltopdf wp)

message=''
fg_red="$(tput setaf 1)"
fg_green="$(tput setaf 2)"
reset="$(tput sgr0)"

# Common messages
YES="${fg_green}OK${reset}"
NO="${fg_red}NO${reset}"
NOT="${fg_red}NOT FOUND${reset}"

echo; echo "=> Checking for required dependencies:"
for i in "${dependencies[@]}" ; do
  check_program "${i}"
done

if [[ -z "${message}" ]] ; then
  #echo "${fg_green}SUCCESS: System is ready!${reset}"
  sleep 1
else
  echo "${fg_red}ERROR: Install missing dependencies and retry installation${reset}"
  # echo ${message};
  exit 1
fi

echo; echo "=> Checking optional dependencies:"
for k in "${options[@]}" ; do
  check_program "${k}"
done

if [[ -n "${message}" ]] ; then
  echo "${fg_red}WARNING: Some extended functionality may not be available${reset}"
  # echo ${message};
fi

# Start the install
echo; sleep 1
if [[ ! -d /etc/deploy ]] || [[ ! -d /etc/deploy/lib ]] || [[ ! -d /etc/deploy/crontab ]]; then
  echo "Creating directories"
  if [[ ! -d /etc/deploy ]]; then
    sudo mkdir /etc/deploy; error_check
  fi

  if [[ ! -d /etc/deploy/lib ]]; then
    sudo mkdir /etc/deploy/lib; error_check
  fi

  if [[ ! -d /etc/deploy/lib/crontab ]]; then
    sudo mkdir /etc/deploy/lib/crontab; error_check
  fi
fi

echo "Installing configuration files"
sudo cp -R etc/* /etc/deploy; error_check
sudo cp etc/.deployrc /etc/deploy; error_check

if [[ ! -f /etc/deploy/deploy.conf ]]; then
  cp /etc/deploy/deploy-example.conf /etc/deploy/deploy.conf; error_check
fi

cp -R lib/* /etc/deploy/lib || error_check
cp deploy.sh /usr/local/bin/deploy || error_check
sudo chmod 755 /usr/local/bin/deploy || error_check
echo "Successfully installed, try typing 'deploy' for help."
