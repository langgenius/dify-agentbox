from __future__ import annotations

from pathlib import Path

from pydantic import BaseModel, ConfigDict, Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class BaseConfig(BaseModel):
    ubuntu: str
    image: str

    model_config = ConfigDict(extra="ignore")


class PythonConfig(BaseModel):
    version: str
    pip_version: str | None = None

    model_config = ConfigDict(extra="ignore")


class NodeJSConfig(BaseModel):
    version: str

    model_config = ConfigDict(extra="ignore")


class GoConfig(BaseModel):
    version: str

    model_config = ConfigDict(extra="ignore")


class RubyConfig(BaseModel):
    version: str

    model_config = ConfigDict(extra="ignore")


class RustConfig(BaseModel):
    version: str

    model_config = ConfigDict(extra="ignore")


class LanguagesConfig(BaseModel):
    python: PythonConfig
    nodejs: NodeJSConfig
    go: GoConfig
    ruby: RubyConfig
    rust: RustConfig

    model_config = ConfigDict(extra="ignore")


class MicromambaConfig(BaseModel):
    version: str | None = None
    conda_forge: bool = True

    model_config = ConfigDict(extra="ignore")


class PythonPackage(BaseModel):
    name: str
    version: str = "latest"

    model_config = ConfigDict(extra="ignore")


class SystemPackages(BaseModel):
    essential: list[str]
    development: list[str]
    libraries: list[str]
    utilities: list[str]
    media: list[str]

    def model_post_init(self, __context) -> None:
        # Deduplicate and sort all system packages lists (case-insensitive, preserve original case)
        self.essential = sorted(list(set(self.essential)), key=str.lower)
        self.development = sorted(list(set(self.development)), key=str.lower)
        self.libraries = sorted(list(set(self.libraries)), key=str.lower)
        self.utilities = sorted(list(set(self.utilities)), key=str.lower)
        self.media = sorted(list(set(self.media)), key=str.lower)

    model_config = ConfigDict(extra="ignore")


class UserConfig(BaseModel):
    name: str
    uid: int
    gid: int
    home: str
    shell: str

    model_config = ConfigDict(extra="ignore")


class PlaywrightConfig(BaseModel):
    browsers: list[str]
    install_deps: bool = True

    model_config = ConfigDict(extra="ignore")


class VersionsConfig(BaseModel):
    base: BaseConfig
    languages: LanguagesConfig
    micromamba: MicromambaConfig | None = None
    python_packages: list[PythonPackage]
    system_packages: SystemPackages
    nodejs_packages: list[str]
    user: UserConfig
    workdir: str
    playwright: PlaywrightConfig

    def model_post_init(self, __context) -> None:
        # Deduplicate and sort Python packages by name (case-insensitive, preserve original case)
        seen_python_packages = {}
        for pkg in self.python_packages:
            seen_python_packages[pkg.name] = pkg
        self.python_packages = sorted(seen_python_packages.values(), key=lambda x: x.name.lower())

        # Deduplicate and sort Node.js packages (case-insensitive, preserve original case)
        self.nodejs_packages = sorted(list(set(self.nodejs_packages)), key=str.lower)

    model_config = ConfigDict(extra="ignore")


class BuildSettings(BaseSettings):
    """Configuration for rendering the Dockerfile."""

    root_dir: Path = Field(default_factory=lambda: Path(__file__).parent.parent)
    versions_file: Path = Field(default_factory=lambda: Path(__file__).parent.parent / "versions" / "versions.yaml")
    template_file: Path = Field(default_factory=lambda: Path(__file__).parent.parent / "Dockerfile.j2")
    output_file: Path = Field(default_factory=lambda: Path(__file__).parent.parent / "Dockerfile")
    scripts_dir: Path = Field(default_factory=lambda: Path(__file__).parent.parent / "scripts")

    model_config = SettingsConfigDict(env_prefix="AGENTBOX_", env_nested_delimiter="__")


def load_versions_model(versions_path: Path) -> VersionsConfig:
    if not versions_path.exists():
        raise FileNotFoundError(f"versions.yaml not found at {versions_path}")
    import yaml

    with versions_path.open("r", encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return VersionsConfig.model_validate(data)
