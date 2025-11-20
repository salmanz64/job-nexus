from fastapi import FastAPI
from models.base import Base
from database import engine
from routes import auth,job


app = FastAPI()

app.include_router(auth.router,prefix='/auth')
app.include_router(job.router,prefix='/job')


Base.metadata.create_all(engine)