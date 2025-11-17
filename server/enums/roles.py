from enum import Enum

class UserRole(str,Enum):
    candidate = "candidate"
    recruiter = "recruiter"