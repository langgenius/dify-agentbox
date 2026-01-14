#!/bin/bash
set -ex

# Initialize micromamba for user
/usr/local/bin/micromamba shell init -s bash -p /opt/conda

# Configure user environment
echo 'export PATH="/opt/conda/bin:/usr/local/go/bin:/home/{{ user.name }}/.cargo/bin:/home/{{ user.name }}/go/bin:$PATH"' >> /home/{{ user.name }}/.bashrc
echo 'export PLAYWRIGHT_BROWSERS_PATH=/opt/playwright-browsers' >> /home/{{ user.name }}/.bashrc
echo 'export GOPATH=/home/{{ user.name }}/go' >> /home/{{ user.name }}/.bashrc
echo 'export GOBIN=/home/{{ user.name }}/go/bin' >> /home/{{ user.name }}/.bashrc
echo 'eval "$(/usr/local/bin/micromamba shell hook --shell bash)"' >> /home/{{ user.name }}/.bashrc
echo 'micromamba activate base 2>/dev/null || true' >> /home/{{ user.name }}/.bashrc
