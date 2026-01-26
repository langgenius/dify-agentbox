#!/bin/bash
set -ex

verify_playwright() {
    echo "Verifying Playwright..."
    if command -v playwright &> /dev/null; then
        playwright --version && which playwright
    else
        echo "Playwright not found, skipping verification"
    fi

    if command -v python3 &> /dev/null; then
        echo "Running Playwright test script..."
        python3 /test/bin/test_playwright.py
        return $?
    endif
}

echo "[agentbox] Verifying packages..."

verify_playwright

echo "[agentbox] All packages verified successfully!"
