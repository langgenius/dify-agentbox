#!/bin/bash
set -ex

echo "[agentbox] Step 2: install runtimes (miniconda/node/go/rust)"

# Detect architecture (x86_64 or aarch64)
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) CONDA_ARCH="x86_64"; GO_ARCH="amd64" ;;
  aarch64|arm64) CONDA_ARCH="aarch64"; GO_ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

# Install Miniconda (replaces micromamba)
curl -fsSLo /tmp/miniconda.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${CONDA_ARCH}.sh"
bash /tmp/miniconda.sh -b -p /opt/conda
rm /tmp/miniconda.sh
/opt/conda/bin/conda config --set always_yes yes --set changeps1 no
/opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
/opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
/opt/conda/bin/conda update -n base -c defaults conda

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_{{ languages.nodejs.version }}.x | bash -
apt-get install -y --no-install-recommends nodejs

# Install Go
GO_VER="{{ languages.go.version }}"
if [[ "$GO_VER" != *.*.* ]]; then
  GO_DL_VER="${GO_VER}.0"
else
  GO_DL_VER="$GO_VER"
fi
wget -q "https://go.dev/dl/go${GO_DL_VER}.linux-${GO_ARCH}.tar.gz"
tar -C /usr/local -xzf "go${GO_DL_VER}.linux-${GO_ARCH}.tar.gz"
rm "go${GO_DL_VER}.linux-${GO_ARCH}.tar.gz"

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain {{ languages.rust.version }}

# Cleanup
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

echo "[agentbox] Step 2 complete"
