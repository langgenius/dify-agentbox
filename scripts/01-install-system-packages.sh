#!/bin/bash
set -ex

echo "[agentbox] Step 1: install system packages"

# Install all system packages
apt-get update && apt-get install -y --no-install-recommends \
    {% for pkg in system_packages.essential -%}
    {{ pkg }} \
    {% endfor -%}
    {% for pkg in system_packages.development -%}
    {{ pkg }} \
    {% endfor -%}
    {% for pkg in system_packages.libraries -%}
    {{ pkg }} \
    {% endfor -%}
    {% for pkg in system_packages.utilities -%}
    {{ pkg }} \
    {% endfor -%}
    {% for pkg in system_packages.media -%}
    {{ pkg }} \
    {% endfor -%}
    ruby-full ruby-dev

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

echo "[agentbox] Step 1 complete"
