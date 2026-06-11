from pydantic import BaseModel, Field


class ProcessReadingRequest(BaseModel):
    text: str = Field(min_length=1)


class TokenData(BaseModel):
    token: str
    focus_index: int
    pace_ms: int


class ProcessReadingResponse(BaseModel):
    result: list[TokenData]
    source: str


class ExtractPdfResponse(BaseModel):
    title: str
    text: str
    page_count: int
