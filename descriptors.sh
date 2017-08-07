#!/bin/sh
# This script helps you to get descriptors for processes running on a mac
# it saves you some time from manually search for the pid and then lookup the 
# descriptors for that pid
#
# The script provide a select list where you can enter the process of which 
# you want to know the descriptors
#
# To call the script give the process name as an argument, for example:
# ./descriptors.sh httpd

IFS=$'\n'
process=${1:?Please enter a process name}

pids=$(ps aux | grep $1)


PS3='Please enter your choice: '
options=( $pids )
select option in "${options[@]}"
do
	pid=$(echo $option | awk '{print $2}' )
	user=$(echo $option | awk '{print $1}' )
	descriptors=$(lsof -p $pid | grep -v 'txt' | grep -v 'cwd')
	if [ -z $descriptors ]; then
		echo "Sorry we couldn't find any descriptors for your choice"
	else 
		echo "The descriptors for $1 with process id $pid and user $user are:"
		echo "$descriptors"
	fi
        break
done

