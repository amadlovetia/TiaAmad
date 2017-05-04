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
sysinfo () {
	# Removing existing bench.log
	rm -rf $HOME/bench.log
	# Reading out system information...
	# Reading CPU model
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading amount of CPU cores
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	# Reading CPU frequency in MHz
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading total memory in MB
	tram=$( free -m | awk 'NR==2 {print $2}' )
	# Reading Swap in MB
	vram=$( free -m | awk 'NR==4 {print $2}' )
	# Reading system uptime
	up=$( uptime | awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading operating system and version (simple, didn't filter the strings at the end...)
	opsy=$( cat /etc/issue.net | awk 'NR==1 {print}' ) # Operating System & Version
	arch=$( uname -m ) # Architecture
	lbit=$( getconf LONG_BIT ) # Architecture in Bit
	hn=$( hostname ) # Hostname
	kern=$( uname -r )
	# Date of benchmark
	bdates=$( date )
	echo "Benchmark started on $bdates" | tee -a $HOME/bench.log
	echo "Full benchmark log: $HOME/bench.log" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# Output of results
	echo "System Info" | tee -a $HOME/bench.log
	echo "-----------" | tee -a $HOME/bench.log
	echo "Processor	: $cname" | tee -a $HOME/bench.log
	echo "CPU Cores	: $cores" | tee -a $HOME/bench.log
	echo "Frequency	: $freq MHz" | tee -a $HOME/bench.log
	echo "Memory		: $tram MB" | tee -a $HOME/bench.log
	echo "Swap		: $vram MB" | tee -a $HOME/bench.log
	echo "Uptime		: $up" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "OS		: $opsy" | tee -a $HOME/bench.log
	echo "Arch		: $arch ($lbit Bit)" | tee -a $HOME/bench.log
	echo "Kernel		: $kern" | tee -a $HOME/bench.log
	echo "Hostname	: $hn" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}

";
PS3='Masukkan Angka Pilihan Yang Diinginkan: '
options=("Buat Akun SSH/VPN" "Buat Akun Trial SSH/VPN" "Mengubah Password Akun SSH/VPN" "Perpanjang Akun SSH/VPN" "Hapus Akun SSH/VPN" "Mematikan Akun SSH/VPN Login Max 2 Device" "Cek Akun Dan Masa Aktif SSH/VPN" "Akun SSH/VPN Aktif" "Akun SSH/VPN Expired" "Mematikan Akun SSH/VPN Yang Sudah Expired" "Benchmark" "Restart Server" "Restart Webmin" "Restart Dropbear" "Ganti Password VPS" "Penggunaan Data VPS Oleh Akun SSH/VPN" "Ram Status" "Melihat Akun SSH/VPN Login Menggunakan Dropbear, OpenSSH, Dan PPTP VPN" "Test Speed VPS" "Mengubah Port OpenVPN" "Mengubah Port Dropbear" "Menambahkan Port Squid" "Quit")
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
		"Mengubah Password Akun SSH/VPN")
			ubahpass
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
		"Mematikan Akun SSH/VPN Yang Sudah Expired")
			bannedexp
			break
			;;
		"Benchmark")
			benchnetwork
			break
			;;
		"Restart Server")
			reboot
			break
			;;
		"Restart Webmin")
			service webmin restart
			break
			;;
		"Restart Dropbear")	
			service dropbear restart
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
