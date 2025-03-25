#!/bin/bash
set -e

sudo apt-get update
sudo apt-get install -y wget software-properties-common

wget https://geth.ethereum.org/downloads/
tar xvf geth-linux-amd64-*.tar.gz
sudo mv geth-linux-amd64-*/* /usr/local/bin/

geth --holesky --syncmode "light" --http --http.port 8345