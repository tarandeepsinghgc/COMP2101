#!/bin/bash

# hostname information
hdata=$(hostname) 
echo "++++++++++++++ HOST ++++++++++++++"
echo "USERDATA: $hdata"

echo "++++++++++ HOSTNAMECTL +++++++++++"
hostnamectl
# os name and version data
echo "++++++++++++++  OS  ++++++++++++++"
operatingSystem=$(hostnamectl | grep -h "Operating Syste")
echo "$operatingSystem"

# ip addresses

echo "++++++++++++++  IP  ++++++++++++++"
ip a | grep -h "ine"

# storage space
echo "+++++++++++++ MEMORY +++++++++++++"
echo "STORAGE: "
memoryAvailable=$(df -h | grep "/dev/s")
echo "$memoryAvailable"
