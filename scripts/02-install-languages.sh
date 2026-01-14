#!/bin/bash
set -ex

# Install Micromamba
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj -C /usr/local bin/micromamba
mkdir -p /opt/conda
/usr/local/bin/micromamba shell init -s bash -p /opt/conda

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
