
# # models/application.py



# import datetime
# from sqlalchemy import Column, DateTime, ForeignKey, String, Text
# from models.base import Base
# from sqlalchemy.orm import relationship


# class Application(Base):
#     __tablename__ = "applications"
    
#     id = Column(String, primary_key=True, index=True)
    
#     # Foreign Keys
#     job_id = Column(String, ForeignKey("jobs.id"), nullable=False)
#     candidate_id = Column(String, ForeignKey("profiles.id"), nullable=False)
    
#     # Application Details
#     status = Column(String, default="applied")  # applied, reviewed, shortlisted, rejected, hired
#     resume_url = Column(String)
    
#     # Timestamps
#     applied_at = Column(DateTime, default=datetime.utcnow)
#     updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
#     # Relationships
#     job = relationship("Job", back_populates="applications")
#     candidate = relationship("Profile", back_populates="applications")