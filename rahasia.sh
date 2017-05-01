#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;

flag=0

echo

function create_user() {
	usernew
}

function renew_user() {
	perpanjang
}

function delete_user(){
	hapususer
}

function expired_users(){
	cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
	totalaccounts=`cat /tmp/expirelist.txt | wc -l`
	for((i=1; i<=$totalaccounts; i++ )); do
		tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
		username=`echo $tuserval | cut -f1 -d:`
		userexp=`echo $tuserval | cut -f2 -d:`
		userexpireinseconds=$(( $userexp * 86400 ))
		todaystime=`date +%s`
		if [ $userexpireinseconds -lt $todaystime ] ; then
			echo $username
		fi
	done
	rm /tmp/expirelist.txt
}

function not_expired_users(){
    cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
    totalaccounts=`cat /tmp/expirelist.txt | wc -l`
    for((i=1; i<=$totalaccounts; i++ )); do
        tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
        username=`echo $tuserval | cut -f1 -d:`
        userexp=`echo $tuserval | cut -f2 -d:`
        userexpireinseconds=$(( $userexp * 86400 ))
        todaystime=`date +%s`
        if [ $userexpireinseconds -gt $todaystime ] ; then
            echo $username
        fi
    done
	rm /tmp/expirelist.txt
}

function used_data(){
	myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`
	myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`
	ifconfig $myint | grep "RX bytes" | sed -e 's/ *RX [a-z:0-9]*/Received: /g' | sed -e 's/TX [a-z:0-9]*/\nTransfered: /g'
}

clear
echo "System by Sebastian Rahmad (Copyright 2016, KeluargaSSH)

For support: Keluarga SSH 
Email: pramadan99@gmail.com
My Facebook: https://www.facebook.com/sebastian.rahmad.26/
SMS/Telegram/Whatsapp: 081268428112

";
PS3='Please enter your choice: '
options=("Buat Akun SSH/VPN" "Buat Akun Trial SSH/VPN" "Perpanjang Akun SSH/VPN" "Hapus Akun SSH/VPN" "Mematikan Akun SSH/VPN Login Max 2 Device" "Cek Akun Dan Masa Aktif SSH/VPN" "Akun SSH/VPN Aktif" "Akun SSH/VPN Expired" "Restart Server" "Ganti Password VPS" "Penggunaan Data VPS Oleh Akun SSH/VPN" "Ram Status" "Melihat Akun SSH/VPN Login Menggunakan Dropbear, OpenSSH, Dan PPTP VPN" "Test Speed VPS" "Mengubah Port OpenVPN" "Mengubah Port Dropbear" "Menambahkan Port Squid" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Buat Akun SSH/VPN")
			create_user
			break
            ;;
		"Buat Akun Trial SSH/VPN")
			trial
			break
			;;
        "Perpanjang Akun SSH/VPN")
            renew_user
            break
            ;;
        "Hapus Akun SSH/VPN")
            delete_user
            break
            ;;		
		"Mematikan Akun SSH/VPN Login Max 2 Device")
			bash userlimit 2
			break
			;;
		"Cek Akun Dan Masa Aktif SSH/VPN")
			cekuser
			break
			;;
		"Akun SSH/VPN Aktif")
			not_expired_users
			break
			;;
		"Akun SSH/VPN Expired")
			expired_users
			break
			;;		
		"Restart Server")
			reboot
			break
			;;	
		"Ganti Password VPS")
			passwd
			break
			;;
		"Penggunaan Data VPS Oleh Akun SSH/VPN")
			used_data
			break
			;;
		"Ram Status")
		    free -h | grep -v + > /tmp/ramcache
            cat /tmp/ramcache | grep -v "Swap"
            break
            ;;
        "Melihat Akun SSH/VPN Login Menggunakan Dropbear, OpenSSH, Dan PPTP VPN")
            userlogin
            break
			;;
		"Test Speed VPS")
			testspeed
			break
			;;
		"Mengubah Port OpenVPN")	
            echo "What OpenVPN port would you like  to change to?"
            read -p "Port: " -e -i 1194 PORT
            sed -i "s/port [0-9]*/port $PORT/" /etc/openvpn/1194.conf
            service openvpn restart
            echo "OpenVPN Updated : Port $PORT"
			break
			;;
		"Mengubah Port Dropbear")	
            echo "What Dropbear port would you like to change to?"
            read -p "Port: " -e -i 443 PORT
            sed -i "s/DROPBEAR_PORT=[0-9]*/DROPBEAR_PORT=$PORT/" /etc/default/dropbear
            service dropbear restart
            echo "Dropbear Updated : Port $PORT"
			break
			;;
        "Menambahkan Port Squid")	
            bash squid.sh
			break
			;;			
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
