# models/application.py
from datetime import datetime
from sqlalchemy import Column, DateTime, ForeignKey, String
from models.base import Base
from sqlalchemy.orm import relationship

class Application(Base):
    __tablename__ = "applications"
    
    id = Column(String, primary_key=True, index=True)
    

    job_id = Column(String, ForeignKey("jobs.id"), nullable=False)
    candidate_id = Column(String, ForeignKey("profiles.id"), nullable=False)  #  PROFILES.ID
    
    # Application Details
    status = Column(String, default="applied")
    resume_url = Column(String, nullable=True)
    
    # Timestamps
    applied_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    job = relationship("Job", back_populates="applications")
    profile = relationship("Profile",back_populates="applications")