#!/bin/bash
set -ex

echo "[agentbox] Step 2: install runtimes (miniconda/node/go/rust)"

# Install Miniconda (replaces micromamba)
curl -fsSLo /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash /tmp/miniconda.sh -b -p /opt/conda
rm /tmp/miniconda.sh
/opt/conda/bin/conda config --set always_yes yes --set changeps1 no
/opt/conda/bin/conda update -n base -c defaults conda

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_{{ languages.nodejs.version }}.x | bash -
apt-get install -y --no-install-recommends nodejs

# Install Go
wget -q https://go.dev/dl/go{{ languages.go.version }}.linux-amd64.tar.gz
tar -C /usr/local -xzf go{{ languages.go.version }}.linux-amd64.tar.gz
rm go{{ languages.go.version }}.linux-amd64.tar.gz

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain {{ languages.rust.version }}

# Cleanup
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

echo "[agentbox] Step 2 complete"

echo "[agentbox] Step 2 complete"
