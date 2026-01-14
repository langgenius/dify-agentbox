#!/bin/bash
set -ex

# Create base environment with Python
/usr/local/bin/micromamba install -y -n base -c conda-forge \
    python={{ languages.python.version }} \
    pip

# Install Python packages
/usr/local/bin/micromamba run -n base pip install --no-cache-dir \
{% for pkg in python_packages -%}
{% if pkg.version == "latest" -%}
    {{ pkg.name }} \
{% else -%}
    "{{ pkg.name }}{{ pkg.version }}" \
{% endif -%}
{% endfor %}

# Cleanup
/usr/local/bin/micromamba clean --all --yes
