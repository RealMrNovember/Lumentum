from pathlib import Path

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

PROJECT_ROOT = Path(__file__).resolve().parents[3]
DATA_DIR = PROJECT_ROOT / "data"
DEFAULT_DB_PATH = DATA_DIR / "lumentum.db"


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=str(PROJECT_ROOT / "packages" / "api" / ".env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    app_name: str = "Lumentum API"
    debug: bool = True

    database_url: str = ""

    jwt_secret: str = "change-me-in-production"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 15
    refresh_token_expire_days: int = 30

    license_api_url: str = "https://license.cicibyte.com"
    license_api_key: str = ""
    license_product_id: str = "lumentum"
    license_mock: bool = False

    cors_origins: str = (
        "http://localhost:3000,"
        "http://localhost:8080,"
        "http://127.0.0.1:8080,"
        "http://localhost:5000,"
        "http://127.0.0.1:5000,"
        "https://lumentum.cicibyte.com"
    )

    @field_validator("database_url", mode="before")
    @classmethod
    def default_database_url(cls, value: str) -> str:
        if value:
            return value
        DATA_DIR.mkdir(parents=True, exist_ok=True)
        return f"sqlite:///{DEFAULT_DB_PATH.as_posix()}"

    @property
    def cors_origin_list(self) -> list[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]

    @property
    def uploads_dir(self) -> Path:
        path = DATA_DIR / "uploads"
        path.mkdir(parents=True, exist_ok=True)
        return path


settings = Settings()
