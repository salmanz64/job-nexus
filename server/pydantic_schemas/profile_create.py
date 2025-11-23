from pydantic import BaseModel, EmailStr
from typing import List, Optional

# ---------- Unified Profile Schema ----------
class ProfileCreate(BaseModel):
    # -------------------------
    # COMMON FIELDS
    # -------------------------
    name: str
    location: Optional[str] = None
    phone: Optional[str] = None
    email: EmailStr
    bio: Optional[str] = None

    # -------------------------
    # RECRUITER FIELDS
    # -------------------------
    industry: Optional[str] = None
    company_size: Optional[str] = None
    founded_year: Optional[int] = None
    website: Optional[str] = None
    specialities: Optional[List[str]] = None   # JSON List

    # -------------------------
    # CANDIDATE FIELDS
    # -------------------------
    experience_years: Optional[int] = None
    job_title: Optional[str] = None
    skills: Optional[List[str]] = None         # JSON List
    education: Optional[str] = None
    resume_url: Optional[str] = None
