#!/bin/bash

CURRENT_USER=$(whoami)
CURRENT_DATE=$(date)
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)

TOTAL_MEM=$(free -m | awk '/^Mem:/{print $2}')
USED_MEM=$(free -m | awk 'NR==2{print $3}')
AVAILABLE_MEM=$(free -m | awk '/^Mem:/ {print $7}')

TOTAL_DISK=$(df -BG --output=size / | tail -1 | sed 's/G//')    #$(df -h --total | awk 'END{print $2}')
USED_DISK=$(df -BG --output=used / | tail -1 | sed 's/G//')
FREE_DISK=$(df -BG --output=avail / | tail -1 | sed 's/G//')

RUNNING_PROCESSES=$(ps -e | wc -l )
TOP_CONSUMING=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 )
#ps: command for processes
#-o pid,cmd,%mem: Specifies format(process id, command, and Memory percentage)
#--sort=-%mem: Sort in descending order

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

clear
echo "===== SYSTEM INFO ====="
echo ""
echo "User: $CURRENT_USER Host: $HOSTNAME"
echo ""
echo "Date: $CURRENT_DATE"
echo ""
echo "  ---Uptime--- "
echo ""
echo "$UPTIME"
echo ""
echo " ---- Memory (MB) ----- "
echo ""
echo "Total: ${TOTAL_MEM} | Used: ${USED_MEM} | Free: ${AVAILABLE_MEM}"

Low=$(( TOTAL_MEM / 4 ))
if [[ "$AVAILABLE_MEM" -le "$Low" ]]; then
    echo -e "\e[31mLow Memory\e[0m"
else
    echo -e "\e[32mSufficient Memory\e[0m"
fi
echo ""
echo " --- Disk Usage --- "
echo ""
echo "Total: ${TOTAL_DISK} | Used: ${USED_DISK} | Free: ${FREE_DISK} "

Low_DISK=$(( TOTAL_DISK / 4 ))
if [[ "$FREE_DISK" -le "$Low_DISK" ]]; then
    echo -e "\e[31mLow Disk Space\e[0m"
else
    echo -e "\e[32mSufficient Disk Space\e[0m"
fi
echo ""
echo " ---- Processes ---- "
echo ""
echo "Running: $RUNNING_PROCESSES " 
echo ""
echo "Top 5 by memory: "
echo "$TOP_CONSUMING "
echo ""
echo " ----- CPU Usage -----"
echo ""
echo "Current cpu usage: ${CPU_USAGE}"
echo ""
echo "============================"

#./sysinfo.sh >> log.txt: Run cmd in terminal to mv output to the log file.