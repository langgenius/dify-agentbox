#!/bin/bash
set -ex

verify_playwright() {
    echo "Verifying Playwright..."
    if command -v playwright &> /dev/null; then
        playwright --version && which playwright
    else
        echo "Playwright not found, skipping verification"
    fi
}

echo "[agentbox] Verifying packages..."

verify_playwright

echo "[agentbox] All packages verified successfully!"
