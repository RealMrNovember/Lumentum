from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.auth.dependencies import get_current_user
from app.database import get_db
from app.license.client import LicenseError, license_client
from app.models.user import User
from app.schemas.license import LicenseActivateRequest, LicenseStatusResponse

router = APIRouter(prefix="/api/license", tags=["license"])


def _apply_license(user: User, result) -> None:
    user.license_status = result.status
    user.license_plan = result.plan_tier
    user.license_expires_at = result.expires_at


@router.get("/status", response_model=LicenseStatusResponse)
def license_status(
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    hwid = user.device_hwid or user.email
    try:
        result = license_client.check(
            email=user.email,
            hwid=hwid,
            client_name=f"{user.first_name} {user.last_name}".strip(),
            platform="web",
        )
    except LicenseError as exc:
        raise HTTPException(status_code=exc.status_code, detail=exc.message) from exc

    _apply_license(user, result)
    db.commit()

    return LicenseStatusResponse(
        email=user.email,
        status=result.status,
        plan_tier=result.plan_tier,
        expires_at=result.expires_at,
    )


@router.post("/activate", response_model=LicenseStatusResponse)
def activate_license(
    body: LicenseActivateRequest,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    try:
        result = license_client.activate(
            email=user.email,
            license_key=body.license_key,
            hwid=body.hwid,
            client_name=f"{user.first_name} {user.last_name}".strip(),
            platform=body.platform,
        )
    except LicenseError as exc:
        raise HTTPException(status_code=exc.status_code, detail=exc.message) from exc

    if not result.is_usable:
        raise HTTPException(status_code=403, detail="Lisans aktif değil veya süresi dolmuş.")

    user.device_hwid = body.hwid
    _apply_license(user, result)
    db.commit()

    return LicenseStatusResponse(
        email=user.email,
        status=result.status,
        plan_tier=result.plan_tier,
        expires_at=result.expires_at,
    )
