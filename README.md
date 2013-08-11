Setup Linux
===========

Setup script for Ubuntu or some similar Linux system

This script is written on Ubuntu 12.04.

## Requirement

- apt-get or yum
- bash

## Usage
	$ git clone https://github.com/r9y9/setup.git && cd install
	$ ./setup.sh

Install command lists are described in the following files.

- package-list/common.list
- package-list/minimum.list
- package-list/server.list
- package-list/deskop.list

 
## Option
### Minimum
	$ ./setup.sh minimum

### Server
	$ ./setup.sh server

### Desktop
	$ ./setup.sh desktop
