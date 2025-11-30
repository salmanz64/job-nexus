from fastapi import FastAPI
from models.base import Base
from database import engine
from routes import auth,job
from routes import application
from routes.chat import router as chat_router


app = FastAPI()

app.include_router(auth.router,prefix='/auth')
app.include_router(job.router,prefix='/job')
app.include_router(application.router,prefix='/application')
app.include_router(chat_router)


Base.metadata.create_all(engine)