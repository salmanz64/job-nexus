# pydantic_schemas/application_create.py
from pydantic import BaseModel
from typing import Optional

class ApplicationCreate(BaseModel):
    job_id: str
    resume_url: Optional[str] = None
    # candidate_id is taken from auth token
    # status defaults to "applied"