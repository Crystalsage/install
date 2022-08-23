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

OPT_INSTALL=0
OPT_INSTALL_DEV=0
OPT_UNINSTALL=0
OPT_UPDATE=0
OPT_HELP=0

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
		fi

		if [[ "$1" = '--uninstall' ]]; then
			OPT_UNINSTALL=1
		fi
		if [[ "$1" = '--update' || "$1" = '-u' ]]; then
			echo "UPDATE"
			OPT_UPDATE=1
		fi
		if [[ "$1" = '--help' || "$1" = '-h' ]]; then
			OPT_HELP=1
		fi

		shift
	done
else 
	usage
fi


# Fetch the latest FLINT AppImage release
fetch_release() {
	HOME_DIR=$HOME/Downloads
	mkdir -p $HOME_DIR

	if [ $OPT_INSTALL_DEV -eq 1 ]; then
		release='dev'
	fi

	echo "Fetching latest version of FLINT"

	#UBUNTU_VERSION=$(cat /etc/os-release | grep ^VERSION_ID | cut -d '=' -f2 | tr -d '"')
	UBUNTU_VERSION="22.04"

	# Get latest release URL
	FLINT_LATEST_VERSION=$(curl -sS $FLINT_GITHUB_URL | jq -r '.assets[].browser_download_url' | grep $UBUNTU_VERSION)
	
	# TODO: What will be the value of `release` in case of stable releases?
	GITHUB_RELEASE_URL="https://github.com/moja-global/install/releases/download/$release/FLINT-ubuntu-$UBUNTU_VERSION.AppImage"

	curl -L $GITHUB_RELEASE_URL --output $HOME_DIR/FLINT.AppImage

	# Check if AppImage is empty or does not exist. 
	if [ -s $HOME_DIR/FLINT.AppImage ]; then
		echo -e "\n\nAppImage fetched successfully!"
	else
		echo "Failed to fetch AppImage"
	fi
}

check_latest_version() {
	version=$(curl -L -Ss $FLINT_GITHUB_URL | jq ".tag_name" | cut -d 'v' -f2 | tr -d '"')
	echo $version
}

main() {
	which jq
	if [ $? -eq 0 ]; then
		echo "jq not found. Please install jq first"
		exit
	fi

	if [ $OPT_INSTALL -eq 1 ]; then
		test -f $APPIMAGE_DIR/FLINT.AppImage
		if [ $? -eq 0 ]; then
			echo "FLINT installation is already present on the system"
			exit
		fi

		fetch_release

		APPIMAGE_DIR=/home/$USER/.local/bin
		mkdir -p $APPIMAGE_DIR
		mv /home/$USER/Downloads/FLINT.AppImage $APPIMAGE_DIR
		chmod +x $APPIMAGE_DIR/FLINT.AppImage
		$APPIMAGE_DIR/FLINT.AppImage 1>/dev/null

		if [ $? -eq 0 ]; then
			echo -e "\n\nInstalled FLINT AppImage at $APPIMAGE_DIR. Please make sure the folder is included in your PATH variable."
		else
			echo -e "\n\nFLINT installation failed!"
			exit
		fi
	fi

	if [ $OPT_UNINSTALL -eq 1 ]; then
		test -f $FLINT_HOME_DIR/FLINT.AppImage
		if [ $? == 0 ]; then
			rm $FLINT_HOME_DIR/FLINT.AppImage
			echo "Uninstalled FLINT AppImage successfully!"
		else
			echo "FLINT installation not found!"
		fi
	fi

	if [ $OPT_UPDATE -eq 1 ]; then
		latest_version=$(check_version)
	fi

	if [ $OPT_HELP -eq 1 ]; then
		usage
	fi
}

main
