#!/bin/bash

result=$(type -t fakeApi)

if [[ $result == "" ]]; then
	echo "Install fakeApi"
	sudo npm install -g api_faker
fi

fakeApi api.js -p 7000 -r http://api.chelaile.net.cn:7000/