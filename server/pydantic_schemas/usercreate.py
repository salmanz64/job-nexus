
from pydantic import BaseModel

from enums.roles import UserRole

class CreateUser(BaseModel):
    name:str
    email:str
    password:str
    role: UserRole