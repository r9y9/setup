#!/bin/bash

# Note that it is recommended to update packages before use this script

# type: 1)minimu, 2)server, 3)desktop
type="minimum"
package_management=""

function check_package_management() {
    messages=()
    if type "apt-get" > /dev/null 2>&1
    then
	package_management="apt-get"
    elif type "yum" > /dev/null 2>&1
    then
	package_management="yum"
    else
	echo "NOT found: apt-get or yum should be installed."
	exit 1
    fi
}

function set_type() {
    case $1 in 
	minimum)
	    type="minimum"
	    ;;
	desktop*)
	    type="desktop"
	    ;;
	server)
	    type="server"
	    ;;
	*)
	    ;;
    esac
}

installed_list=()
not_found_list=()

# $1 : file path to install command list
function create_valid_install_commands_from_file() {
    for command in `cat $1`
    do
	if [ ${package_management} = "apt-get" ]
	then 
	    command_if_exists="apt-cache search --names-only ^$command$"
	elif [ ${package_management} = "yum" ]
	then
	    command_if_exists="yum list *$command | grep ^$command"
	fi
	if [ -n "`$command_if_exists`" ]
	then
	    echo "$command: found"
	    installed_list+=($command)
	else
	    echo "$command: not found"
	    not_found_list+=($command)
	fi
    done
}

function install_commands() {
    check_package_management
    path="./package-list"

    # common install comands list
    if [ -e $path/common ]
    then
	create_valid_install_commands_from_file "$path/common"
    fi

    # user specified command list
    if [ -e $path/$type ]
    then
	create_valid_install_commands_from_file "$path/$type"
    fi
    # install
    echo ${installed_list[@]} | xargs sudo ${package_management} install -y
    if [ ${#not_found_list[@]} -gt 0 ]
    then
	echo "NOT found: ${not_found_list[@]}."
    fi    
}

# TODO
# function install_commands_without_existence_check()


# Install
# su authentication first
sudo echo > /dev/null 2>&1
set_type $1
install_commands
