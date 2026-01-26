#!/bin/bash
set -ex

verify_playwright() {
    echo "Verifying Playwright..."
    playwright --version && which playwright

    # Check architecture
    ARCH=$(uname -m)
    echo "Current architecture: $ARCH"
    
    if [ "$ARCH" != "arm64" ]; then
        echo "Running Playwright test script..."
        python3 /test/bin/test_playwright.py
    else
        echo "Skipping Playwright test script on arm64 architecture"
    fi
}

echo "[agentbox] Verifying packages..."

verify_playwright

echo "[agentbox] All packages verified successfully!"
