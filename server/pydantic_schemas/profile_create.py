from pydantic import BaseModel, EmailStr
from typing import List, Optional

# ---------- Unified Profile Schema ----------
from pydantic import BaseModel, EmailStr
from typing import List, Optional

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
    specialities: Optional[List[str]] = None

    # -------------------------
    # CANDIDATE FIELDS
    # -------------------------
    experience_years: Optional[int] = None
    job_title: Optional[str] = None
    skills: Optional[List[str]] = None
    education: Optional[str] = None
    resume_url: Optional[str] = None

    # -------------------------
    # NEW FIELD
    # -------------------------
    profile_image_url: Optional[str] = None  # Cloudinary URL stored here
