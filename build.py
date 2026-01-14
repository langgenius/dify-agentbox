#!/usr/bin/env python3
"""
Dify AgentBox Dockerfile Renderer

Renders Dockerfile.j2 using versions/versions.yaml and merged shell scripts.
This script only renders the Dockerfile; image building is handled separately.
"""

from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path

from jinja2 import TemplateError
from pydantic import ValidationError

from agentbox_build.config import BuildSettings, load_versions_model
from agentbox_build.renderer import (
    build_install_script,
    build_user_script,
    render_dockerfile,
)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger(__name__)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Render Dockerfile from template")
    parser.add_argument(
        "--output",
        type=Path,
        help="Path to write rendered Dockerfile (default: ./Dockerfile)",
    )
    parser.add_argument(
        "--verbose",
        "-v",
        action="store_true",
        help="Enable verbose logging",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if args.verbose:
        logger.setLevel(logging.DEBUG)

    try:
        settings = BuildSettings()
    except ValidationError as exc:
        logger.error("Settings validation error: %s", exc)
        sys.exit(1)

    try:
        versions = load_versions_model(settings.versions_file)
    except FileNotFoundError as exc:
        logger.error("%s", exc)
        sys.exit(1)
    except ValidationError as exc:
        logger.error("versions.yaml validation error: %s", exc)
        sys.exit(1)

    base_context = versions.model_dump()
    install_script = build_install_script(settings.scripts_dir, base_context)
    configure_user_script = build_user_script(settings.scripts_dir, base_context)

    context = {
        **base_context,
        "install_script": install_script,
        "configure_user_script": configure_user_script,
    }

    output_path = args.output or settings.output_file
    try:
        render_dockerfile(settings.template_file, output_path, context)
    except TemplateError as exc:
        logger.error("Template rendering error: %s", exc)
        sys.exit(1)

    logger.info("Dockerfile rendered to %s", output_path)


if __name__ == "__main__":
    main()
