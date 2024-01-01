#!/bin/bash
arch=$(uname -a)
cpu=$(lscpu | grep "Socket(s)" | tr -s " " | cut -d' ' -f2)
vcpu=$(nproc)
totalmemory=$(free -m | grep "Mem" | tr -s " " | cut -d' ' -f2)
usedmemory=$(free -m | grep "Mem" | tr -s " " | cut -d' ' -f3)
percentage=$(echo "scale=2; $usedmemory *100 / $totalmemory" | bc)
totaldisk=$(df -h --total| grep 'total' | tr -s ' ' | cut -d' ' -f2)
useddisk=$(df -h --total| grep 'total' | tr -s ' ' | cut -d' ' -f3)
percentage1=$(df -h --total| grep 'total' | tr -s ' ' | cut -d' ' -f5)
cpuuse=$(top -bn1 | awk 'NR > 7 {total += $9} END {printf "%.2f", total}')
lastreboot=$(who -b | grep 'system boot' | tr -s ' ' | cut -d' ' -f4)
lastrebootime=$(who -b | grep 'system boot' | tr -s ' ' | cut -d' ' -f5)
lvmactive=$(lsblk | grep 'lvm' | awk '{if (NF > 0) {found=1; exit}} END {if (found) {print "yes"} else {print "no"}}')
connectiontcp=$(netstat -ant | grep 'ESTABLISHED' |wc -l)
usersusing=$(users |wc -l)
ipofuser=$(hostname -I)
ss=$(ip addr | grep "08:00:27:af:1e:c5" | awk '{print $2}')
numberofsudocommand=$(journalctl _COMM=sudo -q | grep COMMAND | wc -l)
wall "
	#Architecture: $arch
	#CPU physical: $cpu
	#VCPU: $vcpu
	#Memory Usage: $usedmemory/$totalmemory MB ($percentage%)
	#Disk Usage:	$useddisk/$totaldisk ($percentage1)
	#CPU load: $cpuuse%
	#last boot: $lastreboot $lastrebootime
	#lvm use: $lvmactive
	#connection TCP: $connectiontcp ESTABLISHED
	#User log: $usersusing
	#Network: IP $ipofuser ($ss)
	#sudo: $numberofsudocommand cmd
"
