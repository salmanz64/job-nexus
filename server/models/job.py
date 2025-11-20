
# models/job.py
from datetime import datetime

from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Text
from models.base import Base
from sqlalchemy.orm import relationship


class Job(Base):
    __tablename__ = "jobs"
    
    id = Column(String, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    requirements = Column(Text, nullable=False)
    responsibilities = Column(Text, nullable=False)
    location = Column(String, nullable=False)
    salary_range = Column(String)  # e.g., "$50k - $80k"
    job_type = Column(String)  # Full-time, Part-time, Contract
    experience_level = Column(String)  # Entry, Mid, Senior
    category = Column(String)  # Engineering, Design, etc.
    skills = Column(String)  # e.g. "Python, FastAPI, Docker"
    
    # Foreign Keys
    recruiter_id = Column(String, ForeignKey("users.id"), nullable=False)

    
    # Status & Timestamps
    status = Column(String, default="active")  # active, closed, draft
    application_count = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    recruiter = relationship("User", back_populates="jobs")

    # applications = relationship("Application", back_populates="job")
