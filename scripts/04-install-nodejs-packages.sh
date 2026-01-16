#!/bin/bash
set -ex

# Install Node.js global packages
npm install -g \
{% for pkg in nodejs_packages -%}
    {{ pkg }} \
{% endfor %}

npm cache clean --force
