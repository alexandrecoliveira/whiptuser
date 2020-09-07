#!/bin/bash

get_user_name() {
#Get the new user's name
	uname=$(whiptail --title "WHIPTUSER" --inputbox "USER NAME: " 10 60 3>&1 1>&2 2>&3)
	echo $uname 
}

get_login() {
#Get the new user's login
	ulogin=$(whiptail --title "WHIPTUSER" --inputbox "LOGIN: " 10 60 3>&1 1>&2 2>&3)
	echo $ulogin | tr A-Z a-z
}

get_last_gid() {
#Get the last group id at /etc/group
	gid=`tail -n1 /etc/group | tr : '\t' | awk '{print $3}'`
	#prox=echo "$(($gid+1))"
	echo "$(($gid+1))"
}

get_last_uid() {
#Get the last user id at /etc/passwd
	gid=`tail -n1 /etc/passwd | tr : '\t' | awk '{print $3}'`
	echo "$(($gid+1))"
}

verify_home_dir() {
#Verify if the directory already exists
	if [ -d $1 ]
	then
		echo 1	#Dir exists
	else
		echo 0	#Dir doesn't exists
	fi
}

usr_login=$(get_login)
usr_id=$(get_last_uid)
group_id=$(get_last_gid)
usr_name=$(get_user_name)	

if (whiptail --title "WHIPTUSER" --yesno "THE DEFAULT SHELL IS SET TO /bin/bash\nKEEP IT ?" 10 60) then
    usr_shell="/bin/bash"
else
	#TO-DO
    usr_shell="undefined" 
fi

#Set the value of usr_home variable based on the response of the function or finish the script otherwise
if [ $(verify_home_dir "/home/$usr_login") -eq 0 ] 
then
	usr_home="/home/$usr_login"
else
	printf "\tError: %s already exists\n" "/home/$usr_login"
	exit 1
fi

printf "$usr_login:x:$usr_id:$group_id:$usr_name,,,:$usr_home:$usr_shell\n"
#echo "$usr_login:x:$usr_id:$group_id:$usr_name,,,:$usr_home:$usr_shell" >> /etc/passwd
printf "\n$usr_login:x:$group_id:\n"
#echo "$usr_login:x:$group_id:" >> /etc/group
