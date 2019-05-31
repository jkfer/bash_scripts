#!/bin/bash

# this file outputs the username and default shell information of the users in the system
# Added password info from chage command
# using arrays to store and re-use values


function print_user {
	
	arr=("$@")
	header=("Username" "UserID" "Primary_G_ID" "User_home" "Default_Shell")
	echo ""

	for ((i = 0; i < 5; i++)); do
		echo "${header[$i]}": "${arr[$i]}"
	done

}


function userinfo {

	user="$1"

	inf=$(grep "$user" /etc/passwd)

	if [ -n "$inf" ]; then

		user_n=$(echo "$inf" | cut -d':' -f 1)
		user_id=$(echo "$inf" | cut -d':' -f 3)
		user_pr_group_id=$(echo "$inf" | cut -d':' -f 4)
		user_home=$(echo "$inf" | cut -d':' -f 6)
		user_shell=$(echo "$inf" | cut -d':' -f 7)

		# Save values to array
		user_inf=("$user_n" "$user_id" "$user_pr_group_id" "$user_home" "$user_shell")

		# get password related detail:
		pw_info=$(chage -l "$user")

		print_user "${user_inf[@]}"
		echo ""
		echo "$pw_info"

	else
		echo "User not found in system."
		exit 1
	fi

}


if [ $# -ne 1 ]; then
	echo "Usage: user_info.sh <username>"
	exit
else
	userinfo "$1"
fi
