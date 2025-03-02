#!/bin/bash

# KeepassXC
sudo add-apt-repository -y ppa:phoerious/keepassxc
sudo apt -y update
sudo apt -y install keepassxc

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get -y update
sudo apt-get install -y spotify-client

# VeraCrypt
sudo add-apt-repository -y ppa:unit193/encryption
sudo apt-get install -y veracrypt
