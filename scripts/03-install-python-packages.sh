#!/bin/bash
set -ex

# Create base environment with Python
/opt/conda/bin/conda install -y -q -n base -c conda-forge \
    python={{ languages.python.version }} \
    pip

# Install Python packages
/opt/conda/bin/pip install --no-cache-dir -q \
{% for pkg in python_packages -%}
{% if pkg.version == "latest" -%}
    "{{ pkg.name }}" \
{% else -%}
    "{{ pkg.name }}{{ pkg.version }}" \
{% endif -%}
{% endfor %}

# Cleanup
/opt/conda/bin/conda clean --all -y
/opt/conda/bin/pip cache purge || true
