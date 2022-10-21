#!/bin/bash

echo "TARANDEEP SINGH - 200493903 - Lab 4"

################
# Data Gathering
################

getInterface=""
while [ $# -gt 0 ]; do
    case "$1" in
    -v )
        verbose="yes"
        ;;
    *)
        # custome interface to tell details of 

        [ "$getInterface" == "" ] && getInterface="$1"
        ;;
    esac

    shift

done

#####
# Once per host report
#####
[ "$verbose" = "yes" ] && echo "Gathering host information"
# we use the hostname command to get our system name and main ip address
my_hostname="$(hostname) / $(hostname -I)"

[ "$verbose" = "yes" ] && echo "Identifying default route"
# the default route can be found in the route table normally
# the router name is obtained with getent
default_router_address=$(ip r s default | awk '{print $3}')
default_router_name=$(getent hosts $default_router_address | awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"
# finding external information relies on curl being installed and relies on live internet connection
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')

cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF

#####
# End of Once per host report
#####

# the second part of the output generates a per-interface report
# the task is to change this from something that runs once using a fixed value for the interface name to
#   a dynamic list obtained by parsing the interface names out of a network info command like "ip"
#   and using a loop to run this info gathering section for every interface found

# the default version uses a fixed name and puts it in a variable
#####
# Per-interface report
#####

# define the interface being summarized
# interface="eno1"
if [ "$getInterface" != "" ]; then

    interface=$getInterface
    [ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"

    [ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
    # Find an address and hostname for the interface being summarized
    # we are assuming there is only one IPV4 address assigned to this interface
    ipv4_address=$(ip a s $interface | awk -F '[/ ]+' '/inet /{print $3}')
    ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

    [ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
    # Identify the network number for this interface and its name if it has one
    # Some organizations have enough networks that it makes sense to name them just like how we name hosts
    # To ensure your network numbers have names, add them to your /etc/networks file, one network to a line, as   networkname networknumber
    #   e.g. grep -q mynetworknumber /etc/networks || (echo 'mynetworkname mynetworknumber' |sudo tee -a /etc/networks)
    network_address=$(ip route list dev $interface scope link | cut -d ' ' -f 1)
    network_number=$(cut -d / -f 1 <<<"$network_address")
    network_name=$(getent networks $network_number | awk '{print $1}')

    cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF

fi

#####
# End of per-interface report
#####
echo "All INTERFACES except 'lo'"

allInterfaces=$(nmcli device status | awk '{print $1}' | awk '(NR>1)' | head -n -1)
for element in $allInterfaces; do
    interface=$element
    [ $interface = "lo" ] && continue
    [ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"
    [ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
    # Find an address and hostname for the interface being summarized
    # we are assuming there is only one IPV4 address assigned to this interface
    ipv4_address=$(ip a s $interface | awk -F '[/ ]+' '/inet /{print $3}')
    ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')
    [ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
    # Identify the network number for this interface and its name if it has one
    # Some organizations have enough networks that it makes sense to name them just like how we name hosts
    # To ensure your network numbers have names, add them to your /etc/networks file, one network to a line, as   networkname networknumber
    #   e.g. grep -q mynetworknumber /etc/networks || (echo 'mynetworkname mynetworknumber' |sudo tee -a /etc/networks)
    network_address=$(ip route list dev $interface scope link | cut -d ' ' -f 1)
    network_number=$(cut -d / -f 1 <<<"$network_address")
    network_name=$(getent networks $network_number | awk '{print $1}')

    cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF

done
