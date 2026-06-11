from fastapi import APIRouter, Depends, File, HTTPException, UploadFile

from app.auth.dependencies import require_license
from app.engine.bridge import process_text
from app.models.user import User
from app.reading.pdf_extract import extract_text_from_pdf
from app.schemas.reading import (
    ExtractPdfResponse,
    ProcessReadingRequest,
    ProcessReadingResponse,
    TokenData,
)

router = APIRouter(prefix="/api/reading", tags=["reading"])


@router.post("/process", response_model=ProcessReadingResponse)
def process_reading(
    body: ProcessReadingRequest,
    _user: User = Depends(require_license),
):
    tokens, source = process_text(body.text)
    if source.startswith("rust-error"):
        raise HTTPException(status_code=500, detail=source)

    return ProcessReadingResponse(
        result=[TokenData(**t) for t in tokens],
        source=source,
    )


@router.post("/extract-pdf", response_model=ExtractPdfResponse)
async def extract_pdf(
    file: UploadFile = File(...),
    _user: User = Depends(require_license),
):
    if not file.filename or not file.filename.lower().endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Yalnızca PDF dosyaları desteklenir.")

    data = await file.read()
    if len(data) > 15 * 1024 * 1024:
        raise HTTPException(status_code=400, detail="PDF en fazla 15 MB olabilir.")

    try:
        title, text, page_count = extract_text_from_pdf(data, file.filename)
    except ValueError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=422, detail="PDF okunamadı.") from exc

    return ExtractPdfResponse(title=title, text=text, page_count=page_count)
