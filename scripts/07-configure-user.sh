#!/bin/bash
set -ex

echo "[agentbox] Step 7: configure user shell"

# Initialize micromamba for user
# Initialize conda for user
/opt/conda/bin/conda init bash

# Configure user environment
echo 'export PATH="/opt/conda/bin:/usr/local/go/bin:/home/{{ user.name }}/.cargo/bin:/home/{{ user.name }}/go/bin:$PATH"' >> /home/{{ user.name }}/.bashrc
echo 'export PLAYWRIGHT_BROWSERS_PATH=/opt/playwright-browsers' >> /home/{{ user.name }}/.bashrc
echo 'export GOPATH=/home/{{ user.name }}/go' >> /home/{{ user.name }}/.bashrc
echo 'export GOBIN=/home/{{ user.name }}/go/bin' >> /home/{{ user.name }}/.bashrc
echo '. /opt/conda/etc/profile.d/conda.sh' >> /home/{{ user.name }}/.bashrc
echo 'conda activate base 2>/dev/null || true' >> /home/{{ user.name }}/.bashrc

echo "[agentbox] Step 7 complete"
