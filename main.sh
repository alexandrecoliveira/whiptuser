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

add_user() {
	echo "Adding $usr_login ..."
	cp -p /etc/group /tmp/etc_passwd.bkp
	echo "$1:x:$2:$3:$4,,,:$5:$6" >> /etc/passwd
	add_primary_group $1 $2
	echo "All done !"
}

add_primary_group() {
	echo "Adding $usr_login to group $group_id..."
	cp -p /etc/group /tmp/etc_group.bkp
	echo "$1:x:$2:" >> /etc/group
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
	mkdir $usr_home
	chown $usr_login:$usr_login $usr_home
	
else
	printf "\tError: %s already exists\n" "/home/$usr_login"
	exit 1
fi

add_user $usr_login $usr_id $group_id $usr_name $usr_home $usr_shell
exit 0	
