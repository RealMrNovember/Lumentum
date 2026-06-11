from typing import Literal

from pydantic import BaseModel, EmailStr, Field


class RegisterRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8)
    first_name: str = Field(min_length=1, max_length=100)
    last_name: str = Field(min_length=1, max_length=100)
    locale: str = "tr"
    hwid: str | None = Field(default=None, min_length=8, max_length=255)
    platform: Literal["web", "desktop"] = "web"


class LoginRequest(BaseModel):
    email: EmailStr
    password: str
    hwid: str | None = Field(default=None, min_length=8, max_length=255)
    platform: Literal["web", "desktop"] = "web"


class UserResponse(BaseModel):
    id: str
    email: str
    first_name: str
    last_name: str
    locale: str
    email_verified: bool
    license_status: str
    license_plan: str
    license_expires_at: str | None = None

    model_config = {"from_attributes": True}


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user: UserResponse


class MessageResponse(BaseModel):
    message: str
