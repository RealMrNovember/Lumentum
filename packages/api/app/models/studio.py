import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, String, Text, UniqueConstraint, func
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base

CONTENT_TYPES = (
    "book",
    "article",
    "poem",
    "news",
    "novel",
    "encyclopedia",
)


class Publication(Base):
    """Wattpad tarzı paylaşılan içerik — kitap, makale, şiir, haber, roman, ansiklopedi."""

    __tablename__ = "publications"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    author_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    title: Mapped[str] = mapped_column(String(300))
    summary: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    body: Mapped[str] = mapped_column(Text)
    content_type: Mapped[str] = mapped_column(String(32), index=True)
    cover_filename: Mapped[str | None] = mapped_column(String(255), nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="published", index=True)
    tags: Mapped[str | None] = mapped_column(String(500), nullable=True)
    like_count: Mapped[int] = mapped_column(Integer, default=0)
    comment_count: Mapped[int] = mapped_column(Integer, default=0)
    view_count: Mapped[int] = mapped_column(Integer, default=0)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )


class PublicationLike(Base):
    __tablename__ = "publication_likes"
    __table_args__ = (
        UniqueConstraint("user_id", "publication_id", name="uq_publication_like"),
    )

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    publication_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("publications.id", ondelete="CASCADE"), index=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )


class PublicationComment(Base):
    __tablename__ = "publication_comments"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    publication_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("publications.id", ondelete="CASCADE"), index=True
    )
    author_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    body: Mapped[str] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
