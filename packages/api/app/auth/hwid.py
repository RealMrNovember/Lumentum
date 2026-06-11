import hashlib
import uuid


def resolve_hwid(
    hwid: str | None,
    *,
    platform: str,
    fallback: str | None = None,
    email: str | None = None,
) -> str:
    """Return a stable HWID for license.cicibyte.com (min 8 chars)."""
    for candidate in (hwid, fallback):
        if candidate and len(candidate.strip()) >= 8:
            return candidate.strip()

    if platform == "web" and email:
        digest = hashlib.sha256(email.strip().lower().encode()).hexdigest()[:24]
        return f"web-{digest}"

    prefix = "web" if platform == "web" else "desktop"
    return f"{prefix}-{uuid.uuid4()}"
