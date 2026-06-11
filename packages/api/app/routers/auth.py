from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.auth.dependencies import get_current_user
from app.auth.hwid import resolve_hwid
from app.auth.security import (
    create_access_token,
    create_refresh_token,
    hash_password,
    verify_password,
)
from app.database import get_db
from app.license.client import LicenseError, license_client
from app.models.user import User
from app.schemas.auth import (
    LoginRequest,
    MessageResponse,
    RegisterRequest,
    TokenResponse,
    UserResponse,
)

router = APIRouter(prefix="/api/auth", tags=["auth"])


def _apply_license(user: User, license_result) -> None:
    user.license_status = license_result.status
    user.license_plan = license_result.plan_tier
    user.license_expires_at = license_result.expires_at


@router.post("/register", response_model=TokenResponse, status_code=201)
def register(body: RegisterRequest, db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.email == body.email.lower()).first()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Bu e-posta zaten kayıtlı",
        )

    client_name = f"{body.first_name} {body.last_name}".strip()
    hwid = resolve_hwid(body.hwid, platform=body.platform, email=body.email)
    try:
        license_result = license_client.start_trial(
            email=body.email.lower(),
            client_name=client_name,
            hwid=hwid,
            platform=body.platform,
        )
    except LicenseError as exc:
        raise HTTPException(status_code=exc.status_code, detail=exc.message) from exc

    if not license_result.is_usable:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="14 günlük deneme lisansı oluşturulamadı",
        )

    user = User(
        email=body.email.lower(),
        password_hash=hash_password(body.password),
        first_name=body.first_name,
        last_name=body.last_name,
        locale=body.locale,
        device_hwid=hwid,
        email_verified=True,
    )
    _apply_license(user, license_result)
    db.add(user)
    db.commit()
    db.refresh(user)

    return TokenResponse(
        access_token=create_access_token(user.id),
        refresh_token=create_refresh_token(user.id),
        user=UserResponse.model_validate(user),
    )


@router.post("/login", response_model=TokenResponse)
def login(body: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == body.email.lower()).first()
    if not user or not verify_password(body.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="E-posta veya şifre hatalı",
        )

    client_name = f"{user.first_name} {user.last_name}".strip()
    hwid = resolve_hwid(
        body.hwid,
        platform=body.platform,
        fallback=user.device_hwid,
        email=user.email,
    )
    try:
        license_result = license_client.check(
            email=user.email,
            hwid=hwid,
            client_name=client_name,
            platform=body.platform,
        )
    except LicenseError as exc:
        raise HTTPException(status_code=exc.status_code, detail=exc.message) from exc

    _apply_license(user, license_result)
    user.device_hwid = hwid
    db.commit()
    db.refresh(user)

    if not license_result.is_usable:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Lisans süresi dolmuş veya askıya alınmış",
        )

    return TokenResponse(
        access_token=create_access_token(user.id),
        refresh_token=create_refresh_token(user.id),
        user=UserResponse.model_validate(user),
    )


@router.get("/me", response_model=UserResponse)
def me(user: User = Depends(get_current_user)):
    return UserResponse.model_validate(user)
