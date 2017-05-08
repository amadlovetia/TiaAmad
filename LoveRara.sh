#!/bin/bash

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# auto reboot 24jam
cd
echo "0 0 * * * root /usr/bin/reboot" > /etc/cron.d/reboot
echo "0 12 * * * root /usr/bin/reboot" > /etc/cron.d/reboot
echo "0 1 * * * root service dropbear restart" > /etc/cron.d/dropbear
echo "0 1 * * * root service ssh restart" >> /etc/cron.d/dropbear
echo "0 6 * * * root service dropbear restart" > /etc/cron.d/dropbear1
echo "0 6 * * * root service ssh restart" >> /etc/cron.d/dropbear1
echo "0 9 * * * root service dropbear restart" > /etc/cron.d/dropbear2
echo "0 9 * * * root service ssh restart" >> /etc/cron.d/dropbear2
echo "0 12 * * * root service dropbear restart" > /etc/cron.d/dropbear3
echo "0 12 * * * root service ssh restart" >> /etc/cron.d/dropbear3
echo "0 15 * * * root service dropbear restart" > /etc/cron.d/dropbear4
echo "0 15 * * * root service ssh restart" >> /etc/cron.d/dropbear4
echo "0 20 * * * root service dropbear restart" > /etc/cron.d/dropbear5
echo "0 20 * * * root service ssh restart" >> /etc/cron.d/dropbear5
echo "0 23 * * * root service dropbear restart" > /etc/cron.d/dropbear6
echo "0 23 * * * root service ssh restart" >> /etc/cron.d/dropbear6
echo "* * * * * root sleep 10; ./userlimit.sh 2" > /etc/cron.d/userlimit2
echo "* * * * * root sleep 20; ./userlimit.sh 2" > /etc/cron.d/userlimit4
echo "* * * * * root sleep 30; ./userlimit.sh 2" > /etc/cron.d/userlimit6
echo "* * * * * root sleep 40; ./userlimit.sh 2" > /etc/cron.d/userlimit8
echo "* * * * * root sleep 50; ./userlimit.sh 2" > /etc/cron.d/userlimit11
echo "0 1 * * * root ./userexpired.sh" > /etc/cron.d/userexpired
echo "0 * * * * root ./clearcache.sh" > /etc/cron.d/clearcache1
echo "10 * * * * root ./clearcache.sh" > /etc/cron.d/clearcache2
echo "20 * * * * root ./clearcache.sh" > /etc/cron.d/clearcache3
echo "30 * * * * root ./clearcache.sh" > /etc/cron.d/clearcache4
echo "40 * * * * root ./clearcache.sh" > /etc/cron.d/clearcache5
echo "50 * * * * root ./clearcache.sh" > /etc/cron.d/clearcache6

# set repo
wget -O /etc/apt/sources.list "https://raw.github.com/arieonline/autoscript/master/conf/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update
apt-get update; apt-get -y upgrade;

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat
vnstat -u -i venet0
service vnstat restart

# install screenfetch
cd
wget https://raw.githubusercontent.com/sean54321/AmadRara/master/screenfetch-dev
mv screenfetch-dev /usr/bin/screenfetch
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.github.com/arieonline/autoscript/master/conf/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by Sebastian Rahmad <3 Mutiara Bunda</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/amadlovetia/TiaAmad/master/conf/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.github.com/arieonline/autoscript/master/conf/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.github.com/arieonline/autoscript/master/conf/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
wget -O /etc/iptables.up.rules "https://raw.github.com/arieonline/autoscript/master/conf/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
MYIP=`curl -s ifconfig.me`;
MYIP2="s/xxxxxxxxx/$MYIP/g";
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules
service openvpn restart

# configure openvpn client config
cd /etc/openvpn/
wget -O /etc/openvpn/1194-client.ovpn "https://raw.github.com/arieonline/autoscript/master/conf/1194-client.conf"
sed -i $MYIP2 /etc/openvpn/1194-client.ovpn;
PASS=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`;
useradd -M -s /bin/false AmadRara
echo "AmadRara:$PASS" | chpasswd
echo "AmadRara" > pass.txt
echo "$PASS" >> pass.txt
tar cf client.tar 1194-client.ovpn pass.txt
cp client.tar /home/vps/public_html/
cd

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.github.com/arieonline/autoscript/master/conf/badvpn-udpgw"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# install mrtg
wget -O /etc/snmp/snmpd.conf "https://raw.github.com/arieonline/autoscript/master/conf/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://raw.github.com/arieonline/autoscript/master/conf/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl "https://raw.github.com/arieonline/autoscript/master/conf/mrtg.conf" >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd

# setting port ssh
wget -O /etc/ssh/sshd_config "https://raw.githubusercontent.com/amadlovetia/TiaAmad/master/conf/sshd_config"
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i 's/eth0/venet0/g' config.php
sed -i "s/\$iface_list = array('venet0', 'sixxs');/\$iface_list = array('venet0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart

# install squid3
apt-get update
wget https://raw.githubusercontent.com/sean54321/AmadRara/master/squid.sh

# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.670_all.deb"
dpkg --install webmin_1.670_all.deb;
apt-get -y -f install;
rm /root/webmin_1.670_all.deb
service webmin restart
service vnstat restart

# install crontab
wget -O /etc/crontab "https://raw.githubusercontent.com/amadlovetia/TiaAmad/master/conf/crontab"

# swap ram
dd if=/dev/zero of=/swapfile bs=1024 count=1024k

# buat swap
mkswap /swapfile

# jalan swapfile
swapon /swapfile

#auto star saat reboot
wget https://raw.githubusercontent.com/iswant/new/master/ram/fstab
mv ./fstab /etc/fstab
chmod 644 /etc/fstab
sysctl vm.swappiness=70

#permission swapfile
chown root:root /swapfile 
chmod 0600 /swapfile

# usernew
wget https://raw.githubusercontent.com/sean54321/AmadRara/master/usernew.sh
cp /root/usernew.sh /usr/bin/usernew
chmod +x /usr/bin/usernew

# userlimit
wget https://raw.githubusercontent.com/amadlovetia/TiaAmad/master/userlimit.sh
cp /root/userlimit.sh /usr/bin/userlimit

# hapususer
wget https://raw.githubusercontent.com/sean54321/AmadRara/master/hapususer.sh
cp /root/hapususer.sh /usr/bin/hapususer
chmod +x /usr/bin/hapususer

# cekuser
wget https://raw.githubusercontent.com/sean54321/AmadRara/master/cekuser.sh
cp /root/cekuser.sh /usr/bin/cekuser
chmod +x /usr/bin/cekuser

# ubahpass
wget https://raw.githubusercontent.com/amadlovetia/TiaAmad/master/ubahpass.sh
cp /root/ubahpass.sh /usr/bin/ubahpass
chmod +x /usr/bin/ubahpass

# bannedexp
wget https://raw.githubusercontent.com/amadlovetia/TiaAmad/master/bannedexp.sh
cp /root/bannedexp.sh /usr/bin/bannedexp
chmod +x /usr/bin/bannedexp

# userlogin
wget https://raw.githubusercontent.com/sean54321/AmadRara/master/userlogin.sh
cp /root/userlogin.sh /usr/bin/userlogin
chmod +x /usr/bin/userlogin

# trial
wget https://raw.githubusercontent.com/sean54321/AmadRara/master/trial.sh
cp /root/trial.sh /usr/bin/trial
chmod +x /usr/bin/trial

# perpanjang
wget https://raw.githubusercontent.com/sean54321/AmadRara/master/perpanjang.sh
cp /root/perpanjang.sh /usr/bin/perpanjang
chmod +x /usr/bin/perpanjang

# testspeed
wget https://raw.githubusercontent.com/sean54321/AmadRara/master/Speed-Test.sh
cp /root/Speed-Test.sh /usr/bin/testspeed
chmod +x /usr/bin/testspeed

# benchnetwork
wget https://raw.githubusercontent.com/sean54321/AmadRara/master/bench-network.sh
cp /root/bench-network.sh /usr/bin/benchnetwork
chmod +x /usr/bin/benchnetwork

# info penggunaan ram
wget -O ps_mem.py "https://raw.github.com/pixelb/ps_mem/master/ps_mem.py"
cp /root/ps_mem.py /usr/bin/usedram
chmod +x /usr/bin/usedram

# menu script
wget https://raw.githubusercontent.com/amadlovetia/TiaAmad/master/rahasia.sh
cp /root/rahasia.sh /usr/bin/menu
chmod +x /usr/bin/menu

# finalisasi
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php-fpm start
service vnstat restart
service openvpn restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart

# info
clear
echo "Sebastian Rahmad <3 Mutiara Bunda" | tee log-install.txt
echo "===============================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://[IP]/client.tar)"  | tee -a log-install.txt
echo "OpenSSH  : 22, 143"  | tee -a log-install.txt
echo "Dropbear : 109, 110, 443, 80"  | tee -a log-install.txt
echo "Squid3   : 8080, 3128 (limit to IP SSH)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Tools"  | tee -a log-install.txt
echo "-----"  | tee -a log-install.txt
echo "axel"  | tee -a log-install.txt
echo "bmon"  | tee -a log-install.txt
echo "htop"  | tee -a log-install.txt
echo "iftop"  | tee -a log-install.txt
echo "mtr"  | tee -a log-install.txt
echo "nethogs"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "Silahkan Tulis : menu"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Fitur lain"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://[IP]:10000/"  | tee -a log-install.txt
echo "vnstat   : http://[IP]/vnstat/"  | tee -a log-install.txt
echo "MRTG     : http://[IP]/mrtg/"  | tee -a log-install.txt
echo "OCS      : http://[IP]:2133/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "SILAHKAN REBOOT VPS ANDA !"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==============================================="  | tee -a log-install.txt
echo ""
echo -e "Script by \e[1;33;44mSebastian Rahmad\e[0m"
