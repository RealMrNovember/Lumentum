import os
import sys
import subprocess
from fastapi import FastAPI, Body

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# Workspace target directories
TARGET_DIRS = [
    os.path.join(BASE_DIR, "target", "release"),
    os.path.join(BASE_DIR, "core_engine_py", "target", "release"),
]

for d in TARGET_DIRS:
    if os.path.isdir(d):
        sys.path.append(d)

HAS_RUST = False
try:
    import lumentum_py  # type: ignore
    HAS_RUST = True
except Exception:
    HAS_RUST = False

HAS_CLI = False
CLI_EXE = None
CLI_NAMES = ["lumentum_engine_cli", "lumentum_engine_cli.exe"]
for d in TARGET_DIRS:
    for name in CLI_NAMES:
        candidate = os.path.join(d, name)
        if os.path.isfile(candidate):
            CLI_EXE = candidate
            HAS_CLI = True
            break
    if HAS_CLI:
        break

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok", "has_rust": HAS_RUST, "has_cli": HAS_CLI}

@app.post("/process")
def process(text: str = Body(..., embed=True)):
    if HAS_RUST:
        try:
            result = lumentum_py.process(text)
            return {"result": result, "source": "rust"}
        except Exception as e:
            return {"error": str(e), "source": "rust-error"}

    if HAS_CLI:
        completed = subprocess.run([CLI_EXE, text], capture_output=True, text=True)
        if completed.returncode == 0:
            lines = completed.stdout.strip().splitlines()
            result = []
            for line in lines:
                parts = line.split("|")
                if len(parts) == 3:
                    result.append({
                        "token": parts[0],
                        "focus_index": int(parts[1]),
                        "pace_ms": int(parts[2])
                    })
            return {"result": result, "source": "rust-cli"}

    tokens = text.split()
    result = [{"token": t, "focus_index": 0, "pace_ms": 100} for t in tokens]
    return {"result": result, "source": "python-fallback"}
