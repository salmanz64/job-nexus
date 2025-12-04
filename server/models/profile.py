from sqlalchemy import INT, TEXT, VARCHAR, Column, ForeignKey
from models.base import Base
from sqlalchemy.orm import relationship

from sqlalchemy import INT, TEXT, VARCHAR, Column, ForeignKey
from models.base import Base
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import JSON




class Profile(Base):
    __tablename__ = "profiles"
    
    id = Column(TEXT, primary_key=True)
    user_id = Column(TEXT, ForeignKey("users.id"), unique=True)

    # ------------------------------
    # COMMON FIELDS
    # ------------------------------
    name = Column(VARCHAR(100))
    location = Column(VARCHAR(100))
    phone = Column(VARCHAR(50))
    email = Column(VARCHAR(100))
    bio = Column(TEXT)
    profile_image_url = Column(VARCHAR(300), nullable=True)


    # ------------------------------
    # RECRUITER FIELDS
    # ------------------------------
    industry = Column(VARCHAR(100), nullable=True)
    company_size = Column(VARCHAR(50), nullable=True)
    founded_year = Column(INT, nullable=True)
    website = Column(VARCHAR(100), nullable=True)
    specialities = Column(JSON, nullable=True)

    # ------------------------------
    # CANDIDATE FIELDS
    # ------------------------------
    experience_years = Column(INT, nullable=True)
    
    
    job_title = Column(VARCHAR(100),nullable=True)

    # list of skills → stored as JSON
    skills = Column(JSON, nullable=True)

    # list of education records → stored as JSON
    education = Column(TEXT, nullable=True)


    resume_url = Column(VARCHAR(300), nullable=True)

    
    
    user = relationship("User", back_populates="profile")
    applications = relationship("Application",back_populates="profile")
    jobs = relationship("Job", back_populates="recruiter")