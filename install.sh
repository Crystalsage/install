#!/usr/bin/env bash

# =============================================================================
#                    Install script for FLINT
# =============================================================================

# Tasks:
# 1. Pull the latest release from the repo
# 2. Install it on a host machine
# 3. Run and test

export FLINT_HOME_DIR=$HOME/.local/bin/


FLINT_GITHUB_URL="https://api.github.com/repos/moja-global/install/releases/latest"
FLINT_LATEST_VERSION=$(curl $FLINT_GITHUB_URL | jq -r '.assets[].browser_download_url')

OPT_INSTALL=0
OPT_UNINSTALL=0

function usage() {
	printf "Install script for FLINT AppImages\n"
	printf "Usage: ./install.sh [parameters]\n\n"
	printf "General options:\n"
	printf "%2s --install <release>: Install FLINT on the system - release can either be 'dev' or 'stable' (default: stable) \n"
	printf "%2s --uninstall: Install FLINT on the system\n"
	printf "%2s --update: Install FLINT on the system\n"
	printf "%2s --help: Install FLINT on the system\n"
}


# Parse the arguments
if [ $# -ne 0 ]; then
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
else 
	print_usage
fi


# Fetch a release from one of the Github releases
fetch_release() {
	HOME_DIR=$USER/Downloads
	
	if $OPT_INSTALL_STABLE == 1; then
		GITHUB_RELEASE_URL="https://github.com"
	else
		GITHUB_RELEASE_URL
	fi


	mkdir -p $HOME_DIR

}

main() {
	if $OPT_INSTALL == 1; then
		fetch_release
	fi

	if $OPT_UNINSTALL == 1; then
		if test -f $USER/.local/bin/flint.AppImage == 0; then
			rm $USER/.local/bin/flint.AppImage
		else
			echo "FLINT Installation not found!"
		fi
	fi

	if $OPT_UPDATE == 1; then
		check_version
	fi

	if $OPT_HELP == 1; then
		usage
	fi

	APPIMAGE_DIR=$USER/.local/bin
	mkdir -p $APPIMAGE_DIR
	mv 
}

main
