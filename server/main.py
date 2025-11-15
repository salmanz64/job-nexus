from fastapi import FastAPI
from models.base import Base
from database import engine


app = FastAPI()

@app.get('/')
def test():
    return 'Hello World';


Base.metadata.create_all(engine)