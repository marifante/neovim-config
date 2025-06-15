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

add_if_missing() {
    local line="$1"
    local file="$2"
    if grep -Fxq "$line" "${file}" 2>/dev/null; then
        log "Line already present: $line"
    else
        echo "$line" >>"${file}"
        log "Added line: $line"
    fi
}

install_reqs() {
    # kitty => used by https://github.com/folke/snacks.nvim/tree/bc0630e43be5699bb94dadc302c0d21615421d93
    # fd => used by Snacks.picker
    # lazygit => used by Snacks.lazygit
    # luarocks => used by luarocks
    # lua5.1 => used by luarocks
    local PKGS_TO_INSTALL=("make" "npm" "curl" "python3-venv" "ripgrep" "fzf" "kitty" "fd-find" "lua5.1" "liblua5.1-dev")

    log "Installing reqs for OS = ${OS}"

    for package in "${PKGS_TO_INSTALL[@]}"; do
        echo "Installing ${package}..."
        ${SYS_INSTALLER} "${package}"
    done

    log "Installing lazygit..."
    local LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -L -o lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/

    log "Installing luarocks..."
    wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
    tar zxpf luarocks-3.11.1.tar.gz
    cd luarocks-3.11.1 && ./configure && make && sudo make install && cd -
    sudo luarocks install luasocket

    log "Installing mmdc tool with npm"
    sudo npm install -g @mermaid-js/mermaid-cli

    log "Set kitty as default terminal emulator"
    sudo update-alternatives --set x-terminal-emulator $(which kitty)

    log "Installing markdown lint cli"
    sudo npm install markdownlint-cli2 --global

    log "Installing chrome-headless-shell needed by diagrams.nvim"
    npx puppeteer browsers install chrome-headless-shell

    log "Installing stuff needed by image.nvim"
    add_if_missing "set -gq allow-passthrough on" "${HOME}/.tmux.conf"
    add_if_missing "set -g visual-activity off" "${HOME}/.tmux.conf"
    sudo apt install -y imagemagick libmagickwand-dev
    log "Please, use kitty as terminal emualator to use image.nvim properly."

    # TODO: install latest node.js version to support copilot
    # https://medium.com/@redswitches/install-the-latest-node-js-version-on-ubuntu-22-04-ca7d7c83a5b0
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
