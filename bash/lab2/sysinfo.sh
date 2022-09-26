#!/bin/bash

echo "Report for myvm"
echo "==============="
# hostname information
hdata=$(hostname)
echo "FQDN: $hdata"
# os name and version data
operatingSystem=$(hostnamectl | grep -h "Operating Syste")
echo "$operatingSystem"
# ip addresses
ip=$(hostname -i)
echo "IP Address: $ip"
# storage space
space=$(df / -h | grep "/dev/sda" | awk '{print $4}')  
echo "Root Filesystem Free Space: $space"
echo "==============="