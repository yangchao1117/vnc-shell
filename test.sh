#!/bin/bash
#echo "user name = ${USER}"
#error=$(lsblk  -f  | grep sdb  |awk 'END{print }' |awk  '{print $6}' | grep  media  |wc -l)
#echo "$error"
#echo "%sudo ALL=(ALL:ALL) ALL"
#echo  "ALL ALL=(ALL:ALL)  NOPASSWD:ALL"  >>/etc/sudoers
#echo "%sudo ALL=(ALL:ALL) ALL" >>/etc/sudoers
#dev=$(ls  /dev/sd* |awk -F  ',' '{print $NF}' | awk 'END{print}')


uuid="422c7f65-c5de-4505-8ade-c1704b3aaade"
dev=$(lsblk -f | grep $uuid |awk  '{print $1}')
sdev=${dev:2:10}
count=0
#echo "count=$count"
usb::mount()
{
	echo "mount"
	error=$(lsblk  -f  | grep $uuid |awk 'END{print }'  | grep  /home/$USER/shared  |wc -l)
	if [ $error -ne 0 ];then
	    echo "device already  mount  /home$USER/shared"
	    return 1
	fi
	error=$(lsblk  -f  | grep $uuid  |awk 'END{print }'  | grep  home  |wc -l)
	if [ $error -eq 0 ];then
	    count=0
	    mkdir -p   /home/$USER/shared
	    sudo mount  /dev/$sdev  /home/$USER/shared
	    echo "device  mount  /home/$USER/shared"
	else
	    count=$[$count+1]
	    echo "wait $count seconds"
	    sleep 1
	    if [ $count -lt 31 ];then
	      usb::mount
	    else echo "no device available mount!"
	    fi
	fi
}
#sudo umount    /home/$USER/shared
usb::umount()
{
	echo "umount"
	utmp=$(lsblk  -f  | grep   /home/$USER/shared  |wc -l)
	#echo $utmp
	if [ $utmp -ne 0 ];then
		sudo umount    /home/$USER/shared
		echo "device  umount finish!"
	else echo "no device umont"
	fi
}
main()
{
	case $1 in 
	    "m" | "mount" )
		usb::mount
	    ;;
	    "u" | "umount" )
		usb::umount
	    ;;
	 esac
}
main $@
