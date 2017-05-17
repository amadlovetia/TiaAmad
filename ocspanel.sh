#!/bin/bash

IP=`dig +short myip.opendns.com @resolver1.opendns.com`

echo "Selamat Datang Di Auto Installer OCS Debian7"
echo "Masukkan Password Yang Anda Inginkan Sesudah Menekan ENTER"
read -p "Tekan ENTER Untuk Melanjutkan"
apt-get update && apt-get -y install mysql-server
mysql_secure_installation
-n
-y
-y
-y
-y
rm /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-available/default
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
mv /etc/nginx/conf.d/vps.conf /etc/nginx/conf.d/vps.conf.backup
wget -O /etc/nginx/nginx.conf "http://script.hostingtermurah.net/repo/blog/ocspanel-debian7/nginx.conf"
wget -O /etc/nginx/conf.d/vps.conf "http://script.hostingtermurah.net/repo/blog/ocspanel-debian7/vps.conf"
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
useradd -m vps && mkdir -p /home/vps/public_html
rm /home/vps/public_html/index.html && echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html && chmod -R g+rw /home/vps/public_html
service php5-fpm restart && service nginx restart
echo "Silahkan Buka Terlebih Dahulu Website: http://$IP:99/info.php"
echo "Perhatian!!! Jika Sudah Membuka Website Nya, Langkah Selanjutnya Menekan ENTER"
echo "Sesudah Menekan ENTER Akan Dimintai Password Yang Kamu Buat Sebelum Nya"
echo "Harap Isi Dengan Benar Ya...."
read -p "Silahkan Tekan ENTER Jika Sudah Melakukan Perintah Diatas"
mysql -u root -p
-CREATE DATABASE IF NOT EXISTS OCSPANEL;EXIT;
apt-get -y install git
cd /home/vps/public_html
git init
git remote add origin https://github.com/stevenindarto/OCSPanel.git
git pull origin master
chmod 777 /home/vps/public_html/config
chmod 777 /home/vps/public_html/config/config.ini
chmod 777 /home/vps/public_html/config/route.ini
echo "Buka Website Ini Terlebih Dahulu: http://$IP:99/"
echo "Jika Sudah Silahkan Isi Database OCS Seperti Format Dibawah"
echo "Bagian DATABASA Isi Seperti Ini: "
echo "Database Host: localhost"
echo "Database Name: OCSPANEL"
echo "Database User: root"
echo "Database Pass: Password Yang Kamu Buat Saat Pertama Instal Tadi"
echo "Bagian Admin Login Isi Seperti Ini: "
echo "Username: Sesuai Keinginan Mu"
echo "Passoword Baru: Sesuai Keinginan Mu"
echo "Masukkan Ulang Password: Samakan Dengan Password Baru"
read -p "Jika Sudah Instalasi Silahkan Tekan ENTER Untuk Melanjutkan"
rm -R /home/vps/public_html/installation
echo ""
echo ""
echo "Sekian Script Auto Installer OCS Panel Dari Sebastian Rahmad"
echo "Saya Ucapkan Terima Kasih"
echo "Silahkan Buka OCS Mu Yak, Isi Website Nya: http://$IP:99/"
