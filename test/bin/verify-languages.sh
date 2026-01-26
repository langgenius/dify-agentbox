#!/bin/bash
set -ex

verify_python() {
    echo "Verifying Python..."
    python --version && which python
    pip --version && which pip
    if command -v conda &> /dev/null; then
        conda --version && which conda
    else
        echo "Conda not found, skipping..."
    fi
}

verify_nodejs() {
    echo "Verifying Node.js..."
    node --version
    npx --version
    npm --version
    pnpm --version

    # Check Node.js version in range
    NODE_VERSION=$(node -v | sed 's/v//')
    if [[ "$(echo "$NODE_VERSION 20" | awk '{print ($1 > $2)}')" -eq 0 ]]; then
        echo "Error: Node.js version must be greater than 20, current version is $NODE_VERSION"
        exit 1
    fi
}

verify_go() {
    echo "Verifying Go..."
    go version && which go
}

verify_rust() {
    echo "Verifying Rust..."
    rustc --version && which rustc
    cargo --version && which cargo
}

verify_ruby() {
    echo "Verifying Ruby..."
    ruby --version && which ruby
    gem --version && which gem
}

echo "[agentbox] Verifying language environments..."

verify_python
verify_nodejs
verify_go
verify_rust
verify_ruby

echo "[agentbox] All language environments verified successfully!"
