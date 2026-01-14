#!/bin/bash
set -ex

# Install Playwright system dependencies
apt-get update
apt-get install -y --no-install-recommends \
    libnss3 libnspr4 libatk-bridge2.0-0 libdrm2 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxrandr2 libgbm1 libxss1

# Install libasound2 - try new package name first (Ubuntu 24.04+), fallback to old name
apt-get install -y --no-install-recommends libasound2t64 || apt-get install -y --no-install-recommends libasound2

apt-get clean
rm -rf /var/lib/apt/lists/*

# Install Playwright browsers in shared location accessible to all users
export PLAYWRIGHT_BROWSERS_PATH=/opt/playwright-browsers
mkdir -p /opt/playwright-browsers
/usr/local/bin/micromamba run -n base playwright install --with-deps {{ playwright.browsers | join(' ') }}

# Set proper permissions for shared access
chmod -R 755 /opt/playwright-browsers

# Create cache directories and symlinks for both users
mkdir -p /home/{{ user.name }}/.cache
mkdir -p /root/.cache
ln -sf /opt/playwright-browsers /home/{{ user.name }}/.cache/ms-playwright
ln -sf /opt/playwright-browsers /root/.cache/ms-playwright
chown -h {{ user.name }}:{{ user.name }} /home/{{ user.name }}/.cache/ms-playwright

# Set environment variable for all users
echo 'export PLAYWRIGHT_BROWSERS_PATH=/opt/playwright-browsers' >> /etc/environment

# Set permissions for shared read-only access
chmod -R 755 /opt/conda
mkdir -p {{ workdir }}
chmod -R g+rws,o+rw {{ workdir }}
chown -R {{ user.name }}:{{ user.name }} {{ workdir }}

# Ensure PATH includes system binaries early in startup
echo 'export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"' >> /etc/environment
echo 'export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"' >> /etc/bash.bashrc

# Set up conda environment activation for all users
echo 'eval "$(/usr/local/bin/micromamba shell hook --shell bash)"' >> /etc/bash.bashrc
echo 'micromamba activate base 2>/dev/null || true' >> /etc/bash.bashrc

# Set up environment for root user
echo 'export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/conda/bin:/usr/local/go/bin:$PATH"' >> /root/.bashrc
echo 'export PLAYWRIGHT_BROWSERS_PATH=/opt/playwright-browsers' >> /root/.bashrc
echo 'eval "$(/usr/local/bin/micromamba shell hook --shell bash)"' >> /root/.bashrc
echo 'micromamba activate base 2>/dev/null || true' >> /root/.bashrc

# Clean up system packages
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
