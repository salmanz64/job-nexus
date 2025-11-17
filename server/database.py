from sqlalchemy.orm import sessionmaker

from sqlalchemy import create_engine

DATABASE_URL = 'postgresql://postgres:salman%401205@localhost:5432/jobnexus'

engine = create_engine(DATABASE_URL)

sessionLocal = sessionmaker(autoflush=False,bind=engine)


def get_db():
    db = sessionLocal()
    try:
        yield db
    finally:
        db.close()