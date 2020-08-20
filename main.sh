#!/bin/bash

get_user_name() {
#Get the new user's name
	val=$(whiptail --title "WHIPTUSER" --inputbox "USER NAME: " 10 60 3>&1 1>&2 2>&3)
	echo $val 
}

get_login() {
#Get the new user's login
	val=$(whiptail --title "WHIPTUSER" --inputbox "LOGIN: " 10 60 3>&1 1>&2 2>&3)
	echo $val | tr A-Z a-z
}

usr_login=$(get_login)
usr_id=-1
group_id=-2
usr_name=$(get_user_name)

if (whiptail --title "WHIPTUSER" --yesno "THE DEFAULT SHELL IS SET TO /bin/bash.\nKEEP IT ?" 10 60) then
    usr_shell="/bin/bash"
else
	#TO-DO
    usr_shell="undefined" 
fi

usr_home="/home/$usr_login"

printf "$usr_login:x:$usr_id:$group_id:$usr_name,,,:$usr_home:$usr_shell\n"

