#!/bin/bash
set -ex

verify_playwright() {
    echo "Verifying Playwright..."
    playwright --version && which playwright

    echo "Running Playwright test script..."
    python3 /test/bin/test_playwright.py
}

echo "[agentbox] Verifying packages..."

verify_playwright

echo "[agentbox] All packages verified successfully!"
