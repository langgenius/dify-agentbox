from __future__ import annotations

from pathlib import Path

from jinja2 import Environment, FileSystemLoader


def strip_shebang(text: str) -> str:
    lines = text.splitlines()
    if lines and lines[0].startswith("#!"):
        lines = lines[1:]
    # Preserve content, only trim trailing newlines to avoid heredoc collapse
    return "\n".join(lines).rstrip("\n") + "\n"


def load_script(path: Path) -> str:
    if not path.exists():
        raise FileNotFoundError(f"Script not found: {path}")
    return strip_shebang(path.read_text(encoding="utf-8"))


def render_snippet(snippet: str, context: dict) -> str:
    template = Environment().from_string(snippet)
    return template.render(**context)


def build_install_script(scripts_dir: Path, context: dict) -> str:
    filenames = [
        "01-install-system-packages.sh",
        "02-install-languages.sh",
        "03-install-python-packages.sh",
        "04-install-nodejs-packages.sh",
        "05-create-user.sh",
        "06-configure-root.sh",
    ]
    parts: list[str] = []
    for filename in filenames:
        script_path = scripts_dir / filename
        step_number = filename.split("-")[0].lstrip("0")
        step_name = filename.split("-", 1)[1].removesuffix(".sh").replace("-", " ")
        rendered = render_snippet(load_script(script_path), context)
        if not rendered.endswith("\n"):
            rendered += "\n"
        # Add step start and complete messages
        wrapped_script = f"echo '[agentbox] Step {step_number}: {step_name}'\n"
        wrapped_script += rendered
        wrapped_script += f"echo '[agentbox] Step {step_number} complete'\n"
        parts.append("RUN <<'EOF'\n" + wrapped_script + "EOF\n")
    return "\n".join(parts)

def build_user_script(scripts_dir: Path, context: dict) -> str:
    user_script = render_snippet(load_script(scripts_dir / "07-configure-user.sh"), context)
    if not user_script.endswith("\n"):
        user_script += "\n"
    # Add step start and complete messages
    wrapped_script = "echo '[agentbox] Step 7: configure user'\n"
    wrapped_script += user_script
    wrapped_script += "echo '[agentbox] Step 7 complete'\n"
    return "RUN <<'EOF'\n" + wrapped_script + "EOF\n"



def render_dockerfile(template_path: Path, output_path: Path, context: dict) -> None:
    env = Environment(
        loader=FileSystemLoader(template_path.parent),
        trim_blocks=True,
        lstrip_blocks=True,
    )
    template = env.get_template(template_path.name)
    content = template.render(**context)
    output_path.write_text(content, encoding="utf-8")