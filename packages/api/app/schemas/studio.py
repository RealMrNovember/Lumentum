from typing import Literal

from pydantic import BaseModel, Field

ContentType = Literal[
    "book", "article", "poem", "news", "novel", "encyclopedia"
]
PublicationStatus = Literal["draft", "published"]


class AuthorBrief(BaseModel):
    id: str
    first_name: str
    last_name: str

    @property
    def display_name(self) -> str:
        return f"{self.first_name} {self.last_name}".strip()


class PublicationCreate(BaseModel):
    title: str = Field(min_length=1, max_length=300)
    summary: str | None = Field(default=None, max_length=1000)
    body: str = Field(min_length=1)
    content_type: ContentType
    status: PublicationStatus = "published"
    tags: list[str] = Field(default_factory=list, max_length=12)


class PublicationUpdate(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=300)
    summary: str | None = Field(default=None, max_length=1000)
    body: str | None = Field(default=None, min_length=1)
    content_type: ContentType | None = None
    status: PublicationStatus | None = None
    tags: list[str] | None = None


class PublicationResponse(BaseModel):
    id: str
    title: str
    summary: str | None
    body: str
    content_type: str
    cover_url: str | None
    status: str
    tags: list[str]
    like_count: int
    comment_count: int
    view_count: int
    liked_by_me: bool = False
    author: AuthorBrief
    created_at: str
    updated_at: str


class PublicationListItem(BaseModel):
    id: str
    title: str
    summary: str | None
    content_type: str
    cover_url: str | None
    like_count: int
    comment_count: int
    view_count: int
    liked_by_me: bool = False
    author: AuthorBrief
    created_at: str


class PublicationFeedResponse(BaseModel):
    items: list[PublicationListItem]
    total: int


class CommentCreate(BaseModel):
    body: str = Field(min_length=1, max_length=2000)


class CommentResponse(BaseModel):
    id: str
    body: str
    author: AuthorBrief
    created_at: str


class LikeResponse(BaseModel):
    liked: bool
    like_count: int
