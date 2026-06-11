import os
import sys
import subprocess
from pathlib import Path

from fastapi import Body, FastAPI

# Monorepo kökü: packages/api → packages → Lumentum
PROJECT_ROOT = Path(__file__).resolve().parents[2]

TARGET_DIRS = [
    PROJECT_ROOT / "target" / "release",
    PROJECT_ROOT / "packages" / "core-engine-py" / "target" / "release",
]

for d in TARGET_DIRS:
    if d.is_dir():
        sys.path.append(str(d))

HAS_RUST = False
try:
    import lumentum_py  # type: ignore

    HAS_RUST = True
except Exception:
    HAS_RUST = False

HAS_CLI = False
CLI_EXE: Path | None = None
CLI_NAMES = ["lumentum_engine_cli", "lumentum_engine_cli.exe"]
for d in TARGET_DIRS:
    for name in CLI_NAMES:
        candidate = d / name
        if candidate.is_file():
            CLI_EXE = candidate
            HAS_CLI = True
            break
    if HAS_CLI:
        break

app = FastAPI(
    title="Lumentum API",
    description="Merkezi shared API — tüm platformlar bu beyinden veri çeker.",
    version="0.1.0",
)


@app.get("/api/health")
def health():
    return {
        "status": "ok",
        "has_rust": HAS_RUST,
        "has_cli": HAS_CLI,
        "architecture": "shared",
    }


@app.post("/api/reading/process")
def process_reading(text: str = Body(..., embed=True)):
    """Metni TokenData listesine dönüştürür. Sözleşme: packages/contracts/schemas/token.json"""
    if HAS_RUST:
        try:
            result = lumentum_py.process(text)
            return {"result": result, "source": "rust"}
        except Exception as e:
            return {"error": str(e), "source": "rust-error"}

    if HAS_CLI and CLI_EXE:
        completed = subprocess.run(
            [str(CLI_EXE), text], capture_output=True, text=True
        )
        if completed.returncode == 0:
            lines = completed.stdout.strip().splitlines()
            result = []
            for line in lines:
                parts = line.split("|")
                if len(parts) == 3:
                    result.append(
                        {
                            "token": parts[0],
                            "focus_index": int(parts[1]),
                            "pace_ms": int(parts[2]),
                        }
                    )
            return {"result": result, "source": "rust-cli"}

    tokens = text.split()
    result = [{"token": t, "focus_index": 0, "pace_ms": 100} for t in tokens]
    return {"result": result, "source": "python-fallback"}


# Geriye dönük uyumluluk (geçici — Faz 1 sonunda kaldırılacak)
@app.get("/health")
def health_legacy():
    return health()


@app.post("/process")
def process_legacy(text: str = Body(..., embed=True)):
    return process_reading(text)
