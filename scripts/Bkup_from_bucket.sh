#!/bin/bash

function coloredEcho(){
    local exp=$1;
    local color=$2;
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput setaf $color;
    echo $exp;
    tput sgr0;
}

new_backups="gs://galera_backups/galera_data_backups/preview-taskflow-cai/backups"
old_backups="gs://galera_backups/galera_data_backups/preview-taskflow-cai/old_backups/"


coloredEcho "You are going to copy backup from google cloud" magenta
coloredEcho "---------------------------"
coloredEcho "But before you go let me clean the backup directory"
cd /mnt/backups
rm -rf *
coloredEcho "---------------------------"
coloredEcho "---------------------------"
read -p "Let me know which week backup you want - Enter Current or Previous  :"  week
coloredEcho "==========================="
coloredEcho "==========================="
coloredEcho "Oh ! You want $week backups" green
coloredEcho "---------------------------"
coloredEcho "---------------------------"

if [ ${week} == Current ]; then
	cd /mnt/backups
	gsutil cp $new_backups/FULL-* .
	gsutil cp $new_backups/inc* .
elif [ ${week} == Previous ]; then
	cd /mnt/backups
	gsutil ls $old_backups | tail -1 > last_week_backup
	last__old_incremental=`cat last_week_backup`
    gsutil cp $last__old_incremental* .
 else
 	coloredEcho "Sorry, I asked for Current or Previous"
 fi

coloredEcho " Now Lets do unzipping"
coloredEcho "---------------------------"
coloredEcho "---------------------------"
coloredEcho "---------------------------"
coloredEcho "Here you go for FULL Backups" blue
cd /mnt/backups
tar -xvf FULL-*
ColoredEcho "---------------------------"
coloredEcho "---------------------------"
coloredEcho "---------------------------"
coloredEcho "Here you go for incremental Backups" blue
coloredEcho "==========================="
coloredEcho "---------------------------"
coloredEcho "###########################"
cd /mnt/backups
ls inc* > incremental_backups
if [ $? -ne 0 ];
then
	coloredEcho "We don't have any Incremental backups Now"
else
	arr=(`cat "incremental_backups" `)
	for i in "${arr[@]}"
	do
	tar -xvf $i
done
fi
coloredEcho "I am removing .gz files" blue
coloredEcho "I am done with backups, Thank you! See you soon" blue
coloredEcho "To resotre backups please use ./xtrabackup.sh resotre" green

coloredEcho "Testinf Git" green








