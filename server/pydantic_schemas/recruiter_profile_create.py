from pydantic import BaseModel, EmailStr
from typing import List, Optional

class RecruiterProfileCreate(BaseModel):
    name: str
    industry: str
    companySize: str
    location: str
    email: EmailStr
    phone: str
    specialities: Optional[List[str]] = None
    bio: Optional[str] = None
    foundedYear: Optional[int] = None
    website: Optional[str] = None
