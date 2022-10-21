#!/bin/bash

# 1. Installing LXD
which lxd >/dev/null
if test $? -ne 0 ; then
	echo "OUTPUT ~~~~~~~~~ LXD INSTALLATION REQUIRED"
	sudo snap install lxd
  else
  echo "OUTPUT ~~~~~~~~~ LXD ALREADY INSTALLED"
fi

# 2. INITIALIZING LXD
ip addr | grep -w lxdbr0 >/dev/null
if test $? -ne 0 ; then
	echo "OUTPUT ~~~~~~~~~ INITIALIZING LXD"
	lxd init --auto
  else
  echo "OUTPUT ~~~~~~~~~ LXD ALREADY INITIALIZED"
fi

# 3. CREATING CONTAINER
lxc list | grep -w "COMP2101-S22" >/dev/null
if test $? -ne 0 ; then
	echo "OUTPUT ~~~~~~~~~ CREATING CONTAINER NAMED 'COMP2101-S22'"
	lxc launch ubuntu:20.04 COMP2101-S22
  else
  echo "OUTPUT ~~~~~~~~~ CONTAINER ALREADY EXISTS"
fi

# 4. INSTALLING APACHE IN THE CONTAINER COMP2101-S22
if lxc exec COMP2101-S22 -- apache2 -v | grep -q 'Server version: Apache/2'; then
    echo "OUTPUT ~~~~~~~~~ APACHE ALREADY INSTALLED"
else
    lxc exec COMP2101-S22 -- apt install apache2
    echo "OUTPUT ~~~~~~~~~ INSTALLING APACHE"
fi