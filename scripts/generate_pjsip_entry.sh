#!/usr/bin/env bash

SEMICOLON=';'
SEPARATOR="$SEMICOLON--------------------------------------------------------------------------------$SEMICOLON";
PASSWORD=$(openssl rand -hex 16)

################################################# HELPER FUNCTIONS #####################################################

function help_text {
	printf "\n\
Usage: \n\
\t ./generate_pjsip_entry.sh [arguments] ... \n\
Example: \n\
\t ./generate_pjsip_entry.sh --user 9999 --name 'Satoshi Nakamoto' \n\
\n\
Arguments: \n\
Option \t\t\t Long option \t\t\t Function \n\
 -u <id> \t\t --user <id> \t\t Specify the user call ID \n\
 -n <name> \t\t --name <name> \t\t Specify the user name \n\
\n"

}


################################################## START UP LOGIC ######################################################

# No parameters passed, print help and exit
[ -z "$1" ] && help_text && exit 0

# Argument Loop
while [ "$1" != "" ]; do
	case $1 in
		"-h" | "--help" )
			help_text
			exit 0
		;;
        	"-u" | "--user" )
			shift
			USER=$1
	        ;;
        	"-n" | "--name" )
			shift
			USERNAME=$1
        	;;
	esac
	shift # get next argument
done

################################################## BASE FUNCTIONS ######################################################

function print_pjsip_config {
	printf "\n\
$SEPARATOR \n\
$SEMICOLON User: $USER Name: $USERNAME \n\
$SEPARATOR \n\
[$USER](endpoint_internal_nat) \n\
auth=$USER-auth \n\
aors=$USER \n\
callerid=$USERNAME <$USER> \n\
\n\
[$USER-auth](auth_userpass) \n\
password=$PASSWORD \n\
username=$USER \n\
\n\
[$USER](aor_dynamic) \n\
$SEPARATOR \n\
\n";

}

function sanity_check {
	if [ -z "$USER" ]; then
		printf "Error: Must provide an user number\n";
		exit 0;
	fi
	if [ -z "$USERNAME" ]; then
                printf "Error: Must provide an user name\n";
                exit 0;
	fi
}

#################################################### BASE LOGIC ########################################################

sanity_check
print_pjsip_config
