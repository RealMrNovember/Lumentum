from pydantic import BaseModel, EmailStr, Field


class LicenseActivateRequest(BaseModel):
    license_key: str = Field(min_length=8, max_length=64)
    hwid: str = Field(min_length=8, max_length=255)
    platform: str = "web"


class LicenseStatusResponse(BaseModel):
    email: EmailStr
    product_id: str = "lumentum"
    status: str
    plan_tier: str
    expires_at: str | None = None
