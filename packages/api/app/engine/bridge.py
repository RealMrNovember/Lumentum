import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[4]

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
for d in TARGET_DIRS:
    for name in ("lumentum_engine_cli", "lumentum_engine_cli.exe"):
        candidate = d / name
        if candidate.is_file():
            CLI_EXE = candidate
            HAS_CLI = True
            break
    if HAS_CLI:
        break


def engine_status() -> dict[str, bool | str]:
    return {
        "has_rust": HAS_RUST,
        "has_cli": HAS_CLI,
        "architecture": "shared",
    }


def process_text(text: str) -> tuple[list[dict], str]:
    if HAS_RUST:
        try:
            result = lumentum_py.process(text)
            return list(result), "rust"
        except Exception as exc:
            return [], f"rust-error:{exc}"

    if HAS_CLI and CLI_EXE:
        completed = subprocess.run(
            [str(CLI_EXE), text], capture_output=True, text=True
        )
        if completed.returncode == 0:
            tokens = []
            for line in completed.stdout.strip().splitlines():
                parts = line.split("|")
                if len(parts) == 3:
                    tokens.append(
                        {
                            "token": parts[0],
                            "focus_index": int(parts[1]),
                            "pace_ms": int(parts[2]),
                        }
                    )
            return tokens, "rust-cli"

    tokens = text.split()
    result = [{"token": t, "focus_index": 0, "pace_ms": 100} for t in tokens]
    return result, "python-fallback"
