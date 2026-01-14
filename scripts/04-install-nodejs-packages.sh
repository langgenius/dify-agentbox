#!/bin/bash
set -ex

echo "[agentbox] Step 4: install Node.js globals"

# Install Node.js global packages
npm install -g \
{% for pkg in nodejs_packages -%}
    {{ pkg }} \
{% endfor %}

npm cache clean --force

echo "[agentbox] Step 4 complete"
