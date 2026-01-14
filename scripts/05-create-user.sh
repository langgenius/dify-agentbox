#!/bin/bash
set -ex

echo "[agentbox] Step 5: create non-root user"

# Remove conflicting UID/GID if exists
if getent passwd {{ user.uid }} >/dev/null 2>&1; then 
    userdel -r $(getent passwd {{ user.uid }} | cut -d: -f1)
fi
if getent group {{ user.gid }} >/dev/null 2>&1; then 
    groupdel $(getent group {{ user.gid }} | cut -d: -f1) 2>/dev/null || true
fi

# Create user and group
groupadd -g {{ user.gid }} {{ user.name }}
useradd -m -u {{ user.uid }} -g {{ user.gid }} -s {{ user.shell }} {{ user.name }}
usermod -aG sudo {{ user.name }}
echo '{{ user.name }} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set empty password for passwordless su
passwd -d {{ user.name }}
passwd -d root

# Copy Rust environment to user
cp -r /root/.cargo /home/{{ user.name }}/.cargo
chown -R {{ user.name }}:{{ user.name }} /home/{{ user.name }}/.cargo

# Create workspace
mkdir -p {{ workdir }}
chown -R {{ user.name }}:{{ user.name }} {{ workdir }}

echo "[agentbox] Step 5 complete"
