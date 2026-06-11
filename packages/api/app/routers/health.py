from fastapi import APIRouter

from app.engine.bridge import engine_status

router = APIRouter(tags=["system"])


@router.get("/api/health")
def health():
    status = engine_status()
    return {"status": "ok", **status}
