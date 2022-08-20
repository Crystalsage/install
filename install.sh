#!/usr/bin/env bash

# =============================================================================
#                    Install script for FLINT
# =============================================================================

# Tasks:
# 1. Pull the latest release from the repo
# 2. Install it on a host machine
# 3. Run and test

export FLINT_HOME_DIR=$HOME/.local/bin/

OPT_INSTALL=0
OPT_UNINSTALL=0

function print_usage() {
	echo "HELP"
}


# Parse the arguments
while [ $# -ne 0 ]
do 
	if [[ "$1" = '--install' || "$1" = '-i' ]]; then
		OPT_INSTALL=1
		shift
		if [[ "$1" = 'dev' ]]; then
			OPT_INSTALL_DEV=1
		fi
		if [[ "$1" = 'stable' ]]; then
			OPT_INSTALL_STABLE=1
		fi
	else
		print_usage
	fi

	if [[ "$1" = '--uninstall' ]]; then
		echo "UNINSTALL"
		OPT_UNINSTALL=1
	fi
	if [[ "$1" = '--update' || "$1" = '-u' ]]; then
		echo "UPDATE"
		OPT_UPDATE=1
	fi
	if [[ "$1" = '--help' || "$1" = '-h' ]]; then
		echo "HELP"
		OPT_HELP=1
	fi

	shift
done

