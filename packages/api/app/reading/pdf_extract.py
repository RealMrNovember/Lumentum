import io
import re

from pypdf import PdfReader


def extract_text_from_pdf(data: bytes, filename: str = "document.pdf") -> tuple[str, str, int]:
    reader = PdfReader(io.BytesIO(data))
    pages: list[str] = []
    for page in reader.pages:
        chunk = (page.extract_text() or "").strip()
        if chunk:
            pages.append(chunk)

    text = re.sub(r"\n{3,}", "\n\n", "\n\n".join(pages)).strip()
    if not text:
        raise ValueError("PDF içinden metin çıkarılamadı (taranmış belge olabilir).")

    title = _title_from_filename(filename)
    return title, text, len(reader.pages)


def _title_from_filename(filename: str) -> str:
    base = filename.rsplit("/", 1)[-1]
    if base.lower().endswith(".pdf"):
        base = base[:-4]
    cleaned = re.sub(r"[_\-]+", " ", base).strip()
    return cleaned or "PDF Document"
