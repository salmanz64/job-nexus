from sqlalchemy import INT, TEXT, VARCHAR, Column, ForeignKey
from models.base import Base


class Profile(Base):
    __tablename__="profiles"
    
    id = Column(TEXT,primary_key=True)
    user_id = Column(TEXT,ForeignKey("users.id"),unique=True)
    
    #common fields
    name = Column(VARCHAR(50),)
    location = Column(VARCHAR(100))
    phone = Column(VARCHAR(20))
    email = Column(VARCHAR(100))
    bio = Column(TEXT)
    
    #recruiter-specific
    industry = Column(VARCHAR(20),nullable=True)
    company_size = Column(VARCHAR(20),nullable=True)
    founded_year = Column(INT,nullable=True)
    website = Column(VARCHAR(50),nullable=True)
    specialities = Column(VARCHAR(200),nullable=True)
    
    
    
    user = relationship("User", back_populates="profile")