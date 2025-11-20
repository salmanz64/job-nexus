# pydantic_schemas/job_create.py
from pydantic import BaseModel
from typing import Optional

class JobCreate(BaseModel):
    title: str
    description: str
    requirements: str
    responsibilities: str  # Add this field
    location: str
    salary_range: Optional[str] = None
    job_type: Optional[str] = None
    experience_level: Optional[str] = None
    category: Optional[str] = None
    skills: Optional[str] = None