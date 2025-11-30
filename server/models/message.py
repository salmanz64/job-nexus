# models.py
from sqlalchemy import Column, Integer, String, DateTime, Boolean
from datetime import datetime
from models.base import Base

class Message(Base):
    __tablename__ = "messages"

    id = Column(Integer, primary_key=True, index=True)
    sender_id = Column(String, nullable=False)
    receiver_id = Column(String, nullable=False)
    content = Column(String)
    timestamp = Column(DateTime, default=datetime.utcnow)
    is_read = Column(Boolean, default=False)
