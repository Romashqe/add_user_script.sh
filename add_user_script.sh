#!/bin/bash

# This script creates a user account in the system 
# by asking username, name and password interactively.
# It then forces the user to change the password on first login.


if [[ "${UID}" -ne 0 ]]
then
	echo "Unable to execute the script. Are you root?"
	exit 1
fi

# Check for 0 arguments
if [[ $# -eq 0 ]]
then
	echo "Usage: $0 USER_NAME [COMMENT]..."
	echo "The first argument is the username and the rest arguments are comment"	
	exit 1
fi

# Let the first argument be the username
# And the other arguments are going to be comment.
USERNAME=$1
shift
COMMENT="$*"

useradd -c "${COMMENT}" -m "${USERNAME}"

if [[ "${?}" -ne 0 ]]
then
	echo "Couldn't create an account"
	exit 1
fi


PASSWD=$(date +%s%N | sha256sum | head -c 12)

echo "${USERNAME}:${PASSWD}" | sudo chpasswd

echo -e "\nYour account was created on "${HOSTNAME}"\nYour username is "${USERNAME}"\nYour password is "${PASSWD}""

# Enforce password change on first login
passwd -e "${USERNAME}" > /dev/null 2>&1

exit 0
