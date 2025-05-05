#! /bin/bash

###############################################################################
## Fixed parameters
NVIM_VER="v0.11.1"
EPOCH=$(date +%s)

###############################################################################
## Variables
SYS_INSTALLER="sudo apt install -y"
OS="Linux"

###############################################################################
## Function
log() {
	echo "$(date +"%Y-%m-%dT%H:%M:%S.%03N") - $*"
}

determine_system_pkg_installer() {
    OS="$(uname -s)"

    log "Determining which package manager to use..."

    if [[ "${OS}" == "Linux" ]]; then
    	SYS_INSTALLER="sudo apt install -y"
    else
    	log "OS not supported: ${OS}"
        exit 1
    fi

    log "This is a ${OS} computer, using ${SYS_INSTALLER} to install..."
}

install_reqs() {
    local PKGS_TO_INSTALL=( "python3-venv" "ripgrep" )

    log "Installing reqs for OS = ${OS}"

    for package in "${PKGS_TO_INSTALL[@]}"; do
        echo "Installing ${package}..."
        ${SYS_INSTALLER} "${package}"
    done
}

install_nvim() {
    local DOWNLOAD_DIR="${HOME}/nvim"
    local DOWNLOAD_PATH="${DOWNLOAD_DIR}/nvim_${NVIM_VER}.appimage"
    local URI="https://github.com/neovim/neovim/releases/download/${NVIM_VER}/nvim-linux-x86_64.appimage"
    local INSTALL_PATH="${HOME}/.local/bin/nvim"

    log "Downloading app.image from ${URI} to ${DOWNLOAD_PATH}"
    mkdir -p ${DOWNLOAD_DIR}
    curl -L -o "${DOWNLOAD_PATH}" "${URI}" 
    chmod u+x "${DOWNLOAD_PATH}"

    log "Creating symbolic link to ${INSTALL_PATH}"
    rm -rf ${INSTALL_PATH}
    ln -s ${DOWNLOAD_PATH} ${INSTALL_PATH}
}

###############################################################################
## Process
determine_system_pkg_installer
install_reqs
install_nvim
