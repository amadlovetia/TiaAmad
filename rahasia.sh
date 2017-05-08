#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;

flag=0

IP=`dig +short myip.opendns.com @resolver1.opendns.com`

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
echo "--------------- Selamat Datang Di Server - Host: $IP ---------------"
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
        # Output of results
        echo "System Info"
        echo "-----------"
        echo -e "\e[34;1mProsessor:\e[0m $cname"
        echo -e "\e[34;1mCPU Cores:\e[0m $cores"
        echo -e "\e[34;1mFrequency:\e[0m $freq MHz"
        echo -e "\e[34;1mMemory:\e[0m    $tram MB"
        echo -e "\e[34;1mSwap:\e[0m      $vram MB"
        echo -e "\e[34;1mUptime:\e[0m    $up"
        echo -e "\e[34;1mOS:\e[0m        $opsy"
        echo -e "\e[34;1mKernel:\e[0m    $kern"
        echo -e "\e[34;1mHostname:\e[0m  $hn"
echo "---------------------------------------------------------------------------"
	echo "Apa Yang Ingin Anda Lakukan?"
	echo -e "\e[031;1m 1\e[0m) Buat Akun SSH/VPN"
	echo -e "\e[031;1m 2\e[0m) Buat Akun Trial SSH/VPN"
	echo -e "\e[031;1m 3\e[0m) Mengubah Password Akun SSH/VPN"
	echo -e "\e[031;1m 4\e[0m) Perpanjang Akun SSH/VPN"
	echo -e "\e[031;1m 5\e[0m) Hapus Akun SSH/VPN"
	echo -e "\e[031;1m 6\e[0m) Mengaktifkan Sistem Pelanggaran Multi Login"
	echo -e "\e[031;1m 7\e[0m) Menonaktifkan Sitem Pelanggaran Multi Login"
	echo -e "\e[031;1m 8\e[0m) Mematikan Akun SSH/VPN Login Max 2 Device"
	echo -e "\e[031;1m 9\e[0m) Cek Akun Dan Masa Aktif SSH/VPN"
	echo -e "\e[031;1m10\e[0m) Akun SSH/VPN Aktif"
	echo -e "\e[031;1m11\e[0m) Akun SSH/VPN Expired"
	echo -e "\e[031;1m12\e[0m) Mematikan Akun SSH/VPN Yang Sudah Expired"
	echo -e "\e[031;1m13\e[0m) Membuat Banner SSH"
	echo -e "\e[031;1m14\e[0m) Benchmark"
	echo -e "\e[031;1m15\e[0m) Restart Server"
	echo -e "\e[031;1m16\e[0m) Restart Webmin"
	echo -e "\e[031;1m17\e[0m) Restart Dropbear"
	echo -e "\e[031;1m18\e[0m) Restart Squid"
	echo -e "\e[031;1m19\e[0m) Ganti Password VPS"
	echo -e "\e[031;1m20\e[0m) Penggunaan Data VPS Oleh Akun SSH/VPN"
	echo -e "\e[031;1m21\e[0m) Ram Status"
	echo -e "\e[031;1m22\e[0m) Melihat Akun SSH/VPN Login Menggunakan Dropbear, OpenSSH, Dan PPTP VPN"
	echo -e "\e[031;1m23\e[0m) Melihat Lokasi User Akun SSH/VPN"
	echo -e "\e[031;1m24\e[0m) Test Speed VPS"
	echo -e "\e[031;1m25\e[0m) Mengubah Port OpenVPN"
	echo -e "\e[031;1m26\e[0m) Mengubah Port Dropbear"
	echo -e "\e[031;1m27\e[0m) Mengubah Port Openssh"
	echo -e "\e[031;1m28\e[0m) Menambahkan Port Squid"
	echo ""
	echo -e "\e[031;1m x\e[0m) Exit"
	echo ""
	read -p "Masukkan Angka Pilihan Yang Diinginkan : " option1
	case $option1 in
	1)
			create_user
            ;;
		2)
			trial
			;;
		3)
			read -p "Isi Nama Username Yang Akan Diubah Password Nya: " uname
		read -p "Silahkan Ditulis Dengan Password Baru: " pass
		echo "$uname:$pass" | chpasswd
		echo "Password Akun SSH/VPN Sudah Diubah Menjadi $pass"
			;;
        4)
            renew_user
            ;;
        5)
            delete_user
            ;;	
	6)
	    service cron restart
	    service ssh restart
	    service dropbear restart
	    echo "------------+ SISTEM SUDAH DI AKTIFKAN +--------------"	  
	echo "Jangan Lupa Dimatikan Sistem Nya, Supaya Tidak Terjadi Apa-Apa"		
	;;
	7)
	rm -rf /etc/cron.d/userlimit1
	rm -rf /etc/cron.d/userlimit2
	rm -rf /etc/cron.d/userlimit3
	rm -rf /etc/cron.d/userlimit4
	rm -rf /etc/cron.d/userlimit5
	rm -rf /etc/cron.d/userlimit6
	service cron restart
	    service ssh restart
	    service dropbear restart
	echo "------------+ SISTEM SUDAH DI NONAKTIFKAN +--------------"
	;;
		8)
			bash userlimit 2
			;;
		9)
			cekuser
			;;
		10)
			not_expired_users
			;;
		11)
			expired_users
			;;	
		12)
			bannedexp
			;;
		13)
			wget -O /etc/default/dropbear "https://raw.githubusercontent.com/amadlovetia/TiaAmad/master/conf/dropbear"
			echo -e "1. Simpan text (CTRL + X, lalu ketik Y dan tekan Enter) 2. Membatalkan edit text (CTRL + X, lalu ketik N dan tekan Enter)"
			read -p "Tekan ENTER Untuk Melanjutkan"
			nano /etc/bannerssh.net
			service ssh restart &&  service dropbear restart
			;;
		14)
			benchnetwork
			;;
		15)
			reboot
			;;
		16)
			service webmin restart
			;;
		17)	
			service dropbear restart
			;;
		18)
			service squid3 restart
			;;
		19)
			read -p "Silahkan Tulis Passsword VPS Baru Anda: " pass	
		echo "root:$pass" | chpasswd
		echo "Password VPS Sudah Diganti Menjadi $pass"
			;;
		20)
			used_data
			;;
		21)
		    free -h | grep -v + > /tmp/ramcache
            cat /tmp/ramcache | grep -v "Swap"
            ;;
        22)
            userlogin
			;;
		23)
	echo "Contoh: 112.123.345.126 lalu Enter"
read -p "Ketik Salah Satu Alamat IP User: " userip
curl ipinfo.io/$userip
			;;
		24)
			testspeed
			;;
		25)
            echo "What OpenVPN port would you like  to change to?"
            read -p "Port: " -e -i 1194 PORT
            sed -i "s/port [0-9]*/port $PORT/" /etc/openvpn/1194.conf
            service openvpn restart
            echo "OpenVPN Updated : Port $PORT"
			;;
		26)
            echo "What Dropbear port would you like to change to?"
            read -p "Port: " -e -i 443 PORT
            sed -i "s/DROPBEAR_PORT=[0-9]*/DROPBEAR_PORT=$PORT/" /etc/default/dropbear
            service dropbear restart
            echo "Dropbear Updated : Port $PORT"
			;;
		27)
            echo "Silahkan ganti port Openssh anda lalu klik enter?"| lolcat
            echo "Port default dan Port 2 tidak boleh sama !!!"| lolcat
	    echo "Port default: 22"| lolcat
	    read -p "Port 2: " -e -i 80 PORT
	    sed -i "s/Port [0-9]*\nPort [0-9]*/Port 22\nPort $PORT/g" /etc/ssh/sshd_config
           # sed -i "s/http_port [0-9]*\nhttp_port [0-9]*/http_port $PORT1\nhttp_port $PORT2/g" /etc/squid3/squid.conf
            service ssh restart
            echo "Openssh Updated Port: $PORT"| lolcat
			;;	
        28)
            bash squid.sh
			;;			
        29)
            ;;		
        x)
            ;;
        *) echo invalid option;;
    esac
