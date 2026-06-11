from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.database import init_db
from app.routers import auth, health, license, reading, studio


def create_app() -> FastAPI:
    application = FastAPI(
        title=settings.app_name,
        description="Merkezi shared API — tüm platformlar bu beyinden veri çeker.",
        version="0.2.0",
    )

    cors_origins = ["*"] if settings.debug else settings.cors_origin_list
    application.add_middleware(
        CORSMiddleware,
        allow_origins=cors_origins,
        allow_credentials=not settings.debug,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    application.include_router(health.router)
    application.include_router(auth.router)
    application.include_router(license.router)
    application.include_router(reading.router)
    application.include_router(studio.router)

    @application.on_event("startup")
    def on_startup() -> None:
        init_db()

    return application
