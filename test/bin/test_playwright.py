#!/usr/bin/env python3
"""
Playwright test script to verify browser functionality.
This script loads a local HTML file and verifies its content.
"""
import logging
import sys
import os
from playwright.sync_api import sync_playwright


def test_playwright_html():
    """
    Test Playwright by loading a local HTML file and verifying its content.
    """
    html_file_path = "/test/test.html"
    
    # Check if HTML file exists
    if not os.path.exists(html_file_path):
        print(f"Error: HTML file not found at {html_file_path}")
        return 1
    
    print(f"Testing Playwright with HTML file: {html_file_path}")
    
    try:
        with sync_playwright() as p:
            # Launch browser in headless mode
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            
            # Load the local HTML file
            page.goto(f"file://{html_file_path}")
            
            # Verify page title
            expected_title = "Playwright Test Page"
            actual_title = page.title()
            print(f"Page title: {actual_title}")
            
            if actual_title != expected_title:
                print(f"Error: Expected title '{expected_title}', got '{actual_title}'")
                browser.close()
                return 1
            
            # Verify h1 element
            h1_text = page.locator("h1").text_content().strip()
            expected_h1 = "Welcome to Playwright Test Page"
            print(f"H1 content: {h1_text}")
            
            if h1_text != expected_h1:
                print(f"Error: Expected h1 '{expected_h1}', got '{h1_text}'")
                browser.close()
                return 1
            
            # Verify specific element by ID
            verify_text = page.locator("#verify-element").text_content().strip()
            expected_verify = "This element is used for verification purposes."
            print(f"Verification element: {verify_text}")
            
            if verify_text != expected_verify:
                print(f"Error: Expected verification text '{expected_verify}', got '{verify_text}'")
                browser.close()
                return 1
            
            # Verify CSS styling (optional)
            verify_color = page.locator("#verify-element").evaluate("el => window.getComputedStyle(el).color")
            print(f"Verification element color: {verify_color}")
            
            # Close browser
            browser.close()
            
            print("✅ Playwright test passed successfully!")
            return 0
            
    except Exception as e:
        logging.exception(f"Error during Playwright test: {str(e)}")
        return 1


if __name__ == "__main__":
    sys.exit(test_playwright_html())