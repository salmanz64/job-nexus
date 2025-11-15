import uuid
import jwt
import bcrypt

from fastapi import APIRouter,Depends,HTTPException
from pydantic_schemas.usercreate import CreateUser
from sqlalchemy.orm import Session
from database import get_db
from models.user import User
from pydantic_schemas.userLogin import LoginUser
from middlewares import auth_middleware



router = APIRouter()

@router.post('/signup',status_code=201)
def signup(user:CreateUser,db:Session = Depends(get_db)):
    userdb = db.query(User).filter(user.email == User.email).first()
    
    if userdb:
        raise HTTPException(400,'User Already Exists')
    
    hashedpw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    
    userdb = User(id=str(uuid.uuid4()),email=user.email,name=user.name,password=user.password)
    
    db.add(userdb)
    db.commit()
    db.refresh(userdb)
    
    return userdb

@router.post('/login',status_code=200)
def loginUser(user:LoginUser,db: Session = Depends(get_db)):
    userdb = db.query(User).filter(user.email==User.email).first()
    
    if not userdb:
        raise HTTPException(400,"User does not exist")
    
    if not bcrypt.checkpw(user.password.encode(),userdb.password):
        raise HTTPException(400,'Incorrect Password')
    
    token = jwt.encode({'id':userdb.id},'password_key')
    
    return {'token':token,'user':userdb}


@router.get('/')
def current_user_data(db:Session=Depends(get_db),user_dict=Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid'])
    
    if not user:
        raise HTTPException(404,'User not found!')
    
    return user