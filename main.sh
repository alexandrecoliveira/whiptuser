#!/bin/bash

get_user_name() {
#Get the new user's name
	val=$(whiptail --title "WHIPTUSER" --inputbox "USER NAME: " 10 60 3>&1 1>&2 2>&3)
	echo $val
}

usr_login='zzz'
usr_id=-1
group_id=-2
usr_name=$(get_user_name)
usr_shell="/bin/bash"
if [ -z "$usr_name" ]
then
	clear	
	printf "... TYPE A NAME TO THE NEW USER ... \n"
	exit 65
fi

usr_home="/home/$usr_name"

printf "$usr_login:x:$usr_id:$group_id:$usr_name,,,:$usr_home:$usr_shell\n"

