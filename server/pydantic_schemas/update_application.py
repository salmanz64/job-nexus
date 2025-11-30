from pydantic import BaseModel
from typing import Optional


class UpdateApplication(BaseModel):
    application_id:str
    status: str
    