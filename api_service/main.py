import os
import sys
from fastapi import FastAPI, Body
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EXT_DIR = os.path.join(BASE_DIR, "core_engine_py", "target", "release")
if os.path.isdir(EXT_DIR):
    sys.path.append(EXT_DIR)
HAS_RUST = False
HAS_CLI = False
CLI_CANDIDATES = [
    os.path.join(BASE_DIR, "core_engine_cli", "target", "release", "lumentum_engine_cli.exe"),
    os.path.join(BASE_DIR, "target", "release", "lumentum_engine_cli.exe"),
]
CLI_EXE = None
for candidate in CLI_CANDIDATES:
    if os.path.isfile(candidate):
        CLI_EXE = candidate
        HAS_CLI = True
        break
try:
    import lumentum_py  # type: ignore
    HAS_RUST = True
except Exception:
    HAS_RUST = False

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/process")
def process(text: str = Body(..., embed=True)):
    if HAS_RUST:
        result = lumentum_py.process(text)
        return {"result": result, "source": "rust"}
    if HAS_CLI:
        import subprocess
        completed = subprocess.run([CLI_EXE, text], capture_output=True, text=True)
        if completed.returncode == 0:
            return {"result": completed.stdout.strip(), "source": "rust-cli"}
    tokens = text.split()
    return {"tokens": tokens, "source": "python"}
