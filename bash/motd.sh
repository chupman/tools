#!/bin/bash
#motd Generator
#written by Chris Hupman chupman@us.ibm.com 01/14/2015

#Color declarations
White="\033[01;37m"
Blue="\033[01;34m"
Green="\033[0;32m"
Red="\033[0;31m"
SilverB="\033[0;46m"
BlueB="\033[0;43m"
Clear="\033[0m"

#System Variables
Hostname=`hostname -s`
Date=`date +"%a, %b %d %Y%l:%M %p"`
Uptime=`uptime |cut -d, -f1 |awk '{print $3 " "$4}'`
NumUsers=`uptime|cut -d, -f3| awk '{print $1}' `
OS=`head -n1 /etc/issue`
DefaultInf=`route |grep default |awk '{print $NF}'`
DefaultIP=`ip -4 a show ${DefaultInf} |grep inet |awk '{print $2}'`
GCC=`cat /proc/version | awk -F "gcc version" '{print $2}' | awk -F "(" '{print $1}'`
CPU=`cat /proc/cpuinfo | grep "model name" |head -n1 | awk '{print $4 " " $5 " "$6" "$7 " "$8 " " $9 " "$10}'`
Memraw=`free -m |grep -i mem | awk '{ print ($2 + 512)}'`
Mem=`expr ${Memraw} / 1024`

#Color Table for future reference prepend with '\033[' for use
#+----------------------------------------------------------------+
#|Black       0;30m    Dark Gray     1;30m    Red Back     0;40m  |
#|Blue        0;34m    Light Blue    1;34m    Green Back   0;41m  |
#|Green       0;32m    Light Green   1;32m    Brown Back   0;42m  |
#|Cyan        0;36m    Light Cyan    1;36m    Blue Back    0;43m  |
#|Red         0;31m    Light Red     1;31m    Purple Back  0;44m  |
#|Purple      0;35m    Light Purple  1;35m    Cyan Back    0;45m  |
#|Brown       0;33m    Yellow        1;33m    Silver Back  0;46m  |
#|Light Gray  0;37m    White         1;3m7    Clear Text   0m     |
#+----------------------------------------------------------------+

echo -e "${Blue}`figlet ${Hostname}`" > /etc/motd
echo -e "${Green}===============================================================================${Blue}" >> /etc/motd
echo -e "The software from this server is being made available for IBM internal use only," >> /etc/motd
echo -e "and it is further limited only to the specific uses of: Development and Testing" >> /etc/motd
echo -e "${Green}===============================================================================${Blue}" >> /etc/motd
echo -en "\033[0m" >> /etc/motd
echo -e "SYSTEM INFORMATION" >> /etc/motd
echo -e "Date: ${Date}  Uptime: ${Uptime}  Users: ${NumUsers}" >> /etc/motd
echo -e "CPU: ${CPU}  Memory: ${Mem} GB"  >> /etc/motd
echo -e "GCC: ${GCC}"  >> /etc/motd
echo -e "IP/Mask: ${DefaultIP}"  >> /etc/motd
echo -e "${Green}===============================================================================${Blue}" >> /etc/motd
echo -e "\033[0m" >> /etc/motd
