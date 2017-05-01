#!/bin/bash

read -p " Isikan Username : " Login
read -p "Password Baru : " Pass
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e "--------------------------------"
echo -e "Password telah diganti dengan $Pass"
echo -e "==========================="
echo -e "Script by \e[1;33;44mSebastian Rahmad\e[0m"
