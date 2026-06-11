import json
import uuid
from pathlib import Path

from fastapi import (
    APIRouter,
    Depends,
    File,
    HTTPException,
    Query,
    UploadFile,
    status,
)
from fastapi.responses import FileResponse
from sqlalchemy import desc, func, select
from sqlalchemy.orm import Session

from app.auth.dependencies import get_current_user
from app.auth.security import decode_token
from app.config import settings
from app.database import get_db
from app.models.studio import Publication, PublicationComment, PublicationLike
from app.models.user import User
from app.schemas.studio import (
    AuthorBrief,
    CommentCreate,
    CommentResponse,
    LikeResponse,
    PublicationCreate,
    PublicationFeedResponse,
    PublicationListItem,
    PublicationResponse,
    PublicationUpdate,
)
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

router = APIRouter(prefix="/api/studio", tags=["studio"])
bearer_optional = HTTPBearer(auto_error=False)

ALLOWED_COVER_TYPES = {"image/jpeg", "image/png", "image/webp"}
MAX_COVER_BYTES = 5 * 1024 * 1024


def _covers_dir() -> Path:
    path = settings.uploads_dir / "covers"
    path.mkdir(parents=True, exist_ok=True)
    return path


def _tags_to_list(raw: str | None) -> list[str]:
    if not raw:
        return []
    try:
        parsed = json.loads(raw)
        if isinstance(parsed, list):
            return [str(t) for t in parsed[:12]]
    except json.JSONDecodeError:
        pass
    return [t.strip() for t in raw.split(",") if t.strip()][:12]


def _tags_to_str(tags: list[str]) -> str | None:
    cleaned = [t.strip() for t in tags if t.strip()][:12]
    return json.dumps(cleaned) if cleaned else None


def _cover_url(pub: Publication) -> str | None:
    if pub.cover_filename:
        return f"/api/studio/covers/{pub.cover_filename}"
    return None


def _author_brief(user: User) -> AuthorBrief:
    return AuthorBrief(
        id=user.id,
        first_name=user.first_name,
        last_name=user.last_name,
    )


def _optional_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_optional),
    db: Session = Depends(get_db),
) -> User | None:
    if credentials is None:
        return None
    user_id = decode_token(credentials.credentials, "access")
    if not user_id:
        return None
    return db.get(User, user_id)


def _liked_ids(db: Session, user_id: str | None, pub_ids: list[str]) -> set[str]:
    if not user_id or not pub_ids:
        return set()
    rows = db.scalars(
        select(PublicationLike.publication_id).where(
            PublicationLike.user_id == user_id,
            PublicationLike.publication_id.in_(pub_ids),
        )
    ).all()
    return set(rows)


def _to_list_item(
    pub: Publication, author: User, liked: bool
) -> PublicationListItem:
    return PublicationListItem(
        id=pub.id,
        title=pub.title,
        summary=pub.summary,
        content_type=pub.content_type,
        cover_url=_cover_url(pub),
        like_count=pub.like_count,
        comment_count=pub.comment_count,
        view_count=pub.view_count,
        liked_by_me=liked,
        author=_author_brief(author),
        created_at=pub.created_at.isoformat(),
    )


def _to_detail(
    pub: Publication, author: User, liked: bool
) -> PublicationResponse:
    return PublicationResponse(
        id=pub.id,
        title=pub.title,
        summary=pub.summary,
        body=pub.body,
        content_type=pub.content_type,
        cover_url=_cover_url(pub),
        status=pub.status,
        tags=_tags_to_list(pub.tags),
        like_count=pub.like_count,
        comment_count=pub.comment_count,
        view_count=pub.view_count,
        liked_by_me=liked,
        author=_author_brief(author),
        created_at=pub.created_at.isoformat(),
        updated_at=pub.updated_at.isoformat(),
    )


@router.get("/feed", response_model=PublicationFeedResponse)
def feed(
    content_type: str | None = Query(default=None),
    search: str | None = Query(default=None, max_length=100),
    limit: int = Query(default=24, ge=1, le=60),
    offset: int = Query(default=0, ge=0),
    db: Session = Depends(get_db),
    viewer: User | None = Depends(_optional_user),
):
    query = (
        select(Publication, User)
        .join(User, User.id == Publication.author_id)
        .where(Publication.status == "published")
    )
    if content_type:
        query = query.where(Publication.content_type == content_type)
    if search:
        like = f"%{search.strip()}%"
        query = query.where(
            Publication.title.ilike(like) | Publication.summary.ilike(like)
        )

    count_q = select(func.count()).select_from(Publication).where(
        Publication.status == "published"
    )
    if content_type:
        count_q = count_q.where(Publication.content_type == content_type)
    if search:
        like = f"%{search.strip()}%"
        count_q = count_q.where(
            Publication.title.ilike(like) | Publication.summary.ilike(like)
        )
    total = db.scalar(count_q) or 0
    rows = db.execute(
        query.order_by(desc(Publication.created_at)).offset(offset).limit(limit)
    ).all()

    pub_ids = [pub.id for pub, _ in rows]
    liked = _liked_ids(db, viewer.id if viewer else None, pub_ids)

    items = [
        _to_list_item(pub, author, pub.id in liked) for pub, author in rows
    ]
    return PublicationFeedResponse(items=items, total=total)


@router.get("/mine", response_model=PublicationFeedResponse)
def my_publications(
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    rows = db.execute(
        select(Publication, User)
        .join(User, User.id == Publication.author_id)
        .where(Publication.author_id == user.id)
        .order_by(desc(Publication.updated_at))
    ).all()
    items = [_to_list_item(pub, author, False) for pub, author in rows]
    return PublicationFeedResponse(items=items, total=len(items))


@router.post("/publications", response_model=PublicationResponse, status_code=201)
def create_publication(
    body: PublicationCreate,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    pub = Publication(
        author_id=user.id,
        title=body.title.strip(),
        summary=body.summary.strip() if body.summary else None,
        body=body.body.strip(),
        content_type=body.content_type,
        status=body.status,
        tags=_tags_to_str(body.tags),
    )
    db.add(pub)
    db.commit()
    db.refresh(pub)
    return _to_detail(pub, user, False)


@router.get("/publications/{publication_id}", response_model=PublicationResponse)
def get_publication(
    publication_id: str,
    db: Session = Depends(get_db),
    viewer: User | None = Depends(_optional_user),
):
    row = db.execute(
        select(Publication, User)
        .join(User, User.id == Publication.author_id)
        .where(Publication.id == publication_id)
    ).first()
    if not row:
        raise HTTPException(status_code=404, detail="İçerik bulunamadı")
    pub, author = row
    if pub.status != "published" and (not viewer or viewer.id != pub.author_id):
        raise HTTPException(status_code=404, detail="İçerik bulunamadı")

    pub.view_count += 1
    db.commit()
    db.refresh(pub)

    liked = False
    if viewer:
        liked = (
            db.query(PublicationLike)
            .filter_by(user_id=viewer.id, publication_id=pub.id)
            .first()
            is not None
        )
    return _to_detail(pub, author, liked)


@router.patch("/publications/{publication_id}", response_model=PublicationResponse)
def update_publication(
    publication_id: str,
    body: PublicationUpdate,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    pub = db.get(Publication, publication_id)
    if not pub or pub.author_id != user.id:
        raise HTTPException(status_code=404, detail="İçerik bulunamadı")

    if body.title is not None:
        pub.title = body.title.strip()
    if body.summary is not None:
        pub.summary = body.summary.strip() or None
    if body.body is not None:
        pub.body = body.body.strip()
    if body.content_type is not None:
        pub.content_type = body.content_type
    if body.status is not None:
        pub.status = body.status
    if body.tags is not None:
        pub.tags = _tags_to_str(body.tags)

    db.commit()
    db.refresh(pub)
    liked = (
        db.query(PublicationLike)
        .filter_by(user_id=user.id, publication_id=pub.id)
        .first()
        is not None
    )
    return _to_detail(pub, user, liked)


@router.delete("/publications/{publication_id}", status_code=204)
def delete_publication(
    publication_id: str,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    pub = db.get(Publication, publication_id)
    if not pub or pub.author_id != user.id:
        raise HTTPException(status_code=404, detail="İçerik bulunamadı")
    if pub.cover_filename:
        cover = _covers_dir() / pub.cover_filename
        cover.unlink(missing_ok=True)
    db.delete(pub)
    db.commit()


@router.post("/publications/{publication_id}/cover", response_model=PublicationResponse)
async def upload_cover(
    publication_id: str,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    pub = db.get(Publication, publication_id)
    if not pub or pub.author_id != user.id:
        raise HTTPException(status_code=404, detail="İçerik bulunamadı")

    content_type = file.content_type or ""
    if content_type not in ALLOWED_COVER_TYPES:
        raise HTTPException(
            status_code=400,
            detail="Kapak için JPEG, PNG veya WebP yükleyin",
        )

    data = await file.read()
    if len(data) > MAX_COVER_BYTES:
        raise HTTPException(status_code=400, detail="Kapak en fazla 5 MB olabilir")

    ext = { "image/jpeg": ".jpg", "image/png": ".png", "image/webp": ".webp" }[
        content_type
    ]
    filename = f"{publication_id}{ext}"
    if pub.cover_filename and pub.cover_filename != filename:
        (_covers_dir() / pub.cover_filename).unlink(missing_ok=True)

    (_covers_dir() / filename).write_bytes(data)
    pub.cover_filename = filename
    db.commit()
    db.refresh(pub)
    return _to_detail(pub, user, False)


@router.get("/covers/{filename}")
def get_cover(filename: str):
    safe = Path(filename).name
    path = _covers_dir() / safe
    if not path.is_file():
        raise HTTPException(status_code=404, detail="Kapak bulunamadı")
    media = {
        ".jpg": "image/jpeg",
        ".jpeg": "image/jpeg",
        ".png": "image/png",
        ".webp": "image/webp",
    }.get(path.suffix.lower(), "application/octet-stream")
    return FileResponse(path, media_type=media)


@router.post("/publications/{publication_id}/like", response_model=LikeResponse)
def toggle_like(
    publication_id: str,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    pub = db.get(Publication, publication_id)
    if not pub or pub.status != "published":
        raise HTTPException(status_code=404, detail="İçerik bulunamadı")

    existing = (
        db.query(PublicationLike)
        .filter_by(user_id=user.id, publication_id=publication_id)
        .first()
    )
    if existing:
        db.delete(existing)
        pub.like_count = max(0, pub.like_count - 1)
        liked = False
    else:
        db.add(
            PublicationLike(
                id=str(uuid.uuid4()),
                user_id=user.id,
                publication_id=publication_id,
            )
        )
        pub.like_count += 1
        liked = True

    db.commit()
    db.refresh(pub)
    return LikeResponse(liked=liked, like_count=pub.like_count)


@router.get(
    "/publications/{publication_id}/comments",
    response_model=list[CommentResponse],
)
def list_comments(
    publication_id: str,
    db: Session = Depends(get_db),
):
    pub = db.get(Publication, publication_id)
    if not pub:
        raise HTTPException(status_code=404, detail="İçerik bulunamadı")

    rows = db.execute(
        select(PublicationComment, User)
        .join(User, User.id == PublicationComment.author_id)
        .where(PublicationComment.publication_id == publication_id)
        .order_by(PublicationComment.created_at)
    ).all()

    return [
        CommentResponse(
            id=comment.id,
            body=comment.body,
            author=_author_brief(author),
            created_at=comment.created_at.isoformat(),
        )
        for comment, author in rows
    ]


@router.post(
    "/publications/{publication_id}/comments",
    response_model=CommentResponse,
    status_code=201,
)
def add_comment(
    publication_id: str,
    body: CommentCreate,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    pub = db.get(Publication, publication_id)
    if not pub or pub.status != "published":
        raise HTTPException(status_code=404, detail="İçerik bulunamadı")

    comment = PublicationComment(
        publication_id=publication_id,
        author_id=user.id,
        body=body.body.strip(),
    )
    db.add(comment)
    pub.comment_count += 1
    db.commit()
    db.refresh(comment)
    return CommentResponse(
        id=comment.id,
        body=comment.body,
        author=_author_brief(user),
        created_at=comment.created_at.isoformat(),
    )
