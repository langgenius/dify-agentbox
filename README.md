# Dify AgentBox

A production-ready, all-in-one Docker image designed for AI agents and autonomous systems that need to execute code across multiple programming languages.

## Why AgentBox?

AI agents often need to:
- Execute code in multiple languages (Python, JavaScript, Go, etc.)
- Process documents, images, and multimedia
- Interact with web browsers for automation
- Access databases and external services

Instead of managing separate containers or installing dependencies on-the-fly, AgentBox provides everything pre-configured in a single, secure image.

## What's Inside

- **Multi-language runtime**: Python, Node.js, Go, Ruby, Rust
- **Document processing**: PDF, Excel, PowerPoint, Word, HTML
- **Browser automation**: Playwright with Chromium & Firefox
- **Data tools**: pandas, numpy, database clients (MySQL, PostgreSQL, SQLite)
- **Media processing**: ffmpeg, image manipulation
- **Development tools**: git, build tools, debuggers

## Quick Start

```bash
docker run -it --rm -v $(pwd):/workspace langgenius/dify-agentbox:latest
```

## Use Cases

- **AI Agent Execution**: Run LLM-generated code safely in isolated environments
- **Code Interpreters**: Execute user code across multiple languages
- **Document Processing**: Convert, extract, and transform documents at scale
- **Browser Automation**: Scrape websites, test web applications, automate workflows
- **CI/CD Pipelines**: Universal build environment with all tools included

## Managing This Repository

### Project Structure

```
dify-agentbox/
├── versions/versions.yaml    # Version configuration for all packages
├── Dockerfile.j2              # Jinja2 template for generating Dockerfile
├── build.py                   # Build script to render and build images
└── .github/workflows/         # CI/CD automation
```

### Making Changes

**1. Update Package Versions**

Edit `versions/versions.yaml`:

```yaml
languages:
  python:
    version: "3.12"
  nodejs:
    version: "20"

python_packages:
  - name: "pandas[excel,html,xml]"
    version: "~=2.2.3"
```

**2. Render Dockerfile locally**

```bash
# Install dependencies
uv sync

# Render Dockerfile
uv run python build.py

# Build the image with Docker
docker build -t langgenius/dify-agentbox:dev .
```

**3. Test Changes**

```bash
# Run the image
docker run -it --rm langgenius/dify-agentbox:dev

# Verify installations
python --version
node --version
go version
```

### CI/CD Workflow

Images are automatically built and pushed when:
- **Push to main**: Builds and tags as `latest`
- **Create tag** (e.g., `v1.0.0`): Builds and tags with semantic version
- **Pull request**: Validates build without pushing

Multi-architecture builds (amd64, arm64) are enabled by default.

### Adding New Packages

**System packages** (apt):
```yaml
system_packages:
  utilities:
    - your-package-name
```

**Python packages**:
```yaml
python_packages:
  - name: "your-package"
    version: "~=1.0.0"
```

**Node.js packages**:
```yaml
nodejs_packages:
  - your-global-package
```

After making changes, rebuild and test locally before pushing.

## License

Apache 2.0
