#! /bin/bash

os=$(uname -s)

if [[ "${os}" == "Darwin" ]]; then
	INSTALL="brew install"
elif [[ "${os}" == "Linux" ]]; then
	INSTALL="apt install"
	${INSTALL} python3.10-venv
else
	echo "OS not supported: ${os}"
fi

${INSTALL} ripgrep
