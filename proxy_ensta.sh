#!/bin/bash

# This script works for Ubuntu 16.04

# Proxy configuration
PROXY_COMMON="192.168.1.10:3128"
PROXY_SOCKS="192.168.1.10:822"
NO_PROXY="localhost,127.0.0.0/8,ensieta.ecole,ensieta.fr,ensta-bretagne.fr"
PROXY_FILE=/etc/apt/apt.conf.d/proxy

proxy_on(){
	echo "# Bash configuration"
	# bash
	export https_proxy=https://$PROXY_COMMON
	export http_proxy=http://$PROXY_COMMON
	export ftp_proxy=ftp://$PROXY_COMMON
	export socks_proxy=socks://$PROXY_SOCKS
	export no_proxy=$NO_PROXY

	echo "# Apt configuration"
	# apt
	sudo touch $PROXY_FILE
	echo "# Proxy configuration for apt" | sudo tee $PROXY_FILE 
	echo "Acquire::http::Proxy \"http://$PROXY_COMMON\";" | sudo tee -a $PROXY_FILE
	echo "Acquire::ftp::Proxy \"ftp://$PROXY_COMMON\";" | sudo tee -a $PROXY_FILE
	echo "Acquire::https::Proxy \"https://$PROXY_COMMON\";" | sudo tee -a $PROXY_FILE
	echo "Acquire::socks::Proxy \"socks://$PROXY_SOCKS\";" | sudo tee -a $PROXY_FILE

	echo "# Git configuration"
	# git
	git config --global http.proxy http://$PROXY_COMMON
}

proxy_off(){

	echo "# Bash configuration"
	# bash
	unset https_proxy
	unset http_proxy
	unset ftp_proxy
	unset socks_proxy
	unset no_proxy

	echo "# Apt configuration"
	# apt
	sudo touch $PROXY_FILE
	echo "# Proxy configuration for apt" | sudo tee $PROXY_FILE

	echo "# Git configuration"
	# git
	git config --global --unset http.proxy
}

show_help(){
	echo "proxy_ensta [on|off]"
	echo ""
	echo "on : activate proxy for bash, apt and git"
	echo "off : desactivate proxy for bash, apt and git"
}

if [ $# -eq 0 ]
then
	show_help
else
	if [ $1 == "on" ]
	then
		proxy_on
	fi
	if [ $1 == "off" ]
	then
		proxy_off
	fi
fi
