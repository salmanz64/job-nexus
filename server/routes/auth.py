import uuid
import jwt
import bcrypt

from fastapi import APIRouter,Depends,HTTPException
from pydantic_schemas.usercreate import CreateUser
from sqlalchemy.orm import Session
from database import get_db
from models.user import User
from pydantic_schemas.userLogin import LoginUser
from middlewares.auth_middleware import auth_middleware
from pydantic_schemas.profile_create import ProfileCreate
from models.profile import Profile



router = APIRouter()

@router.post('/signup',status_code=201)
def signup(user:CreateUser,db:Session = Depends(get_db)):
    userdb = db.query(User).filter(user.email == User.email).first()
    
    if userdb:
        raise HTTPException(400,'User Already Exists')
    
    hashedpw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    
    userdb = User(id=str(uuid.uuid4()),email=user.email,name=user.name,password=hashedpw,role=user.role)
    
    
    db.add(userdb)
    db.commit()
    db.refresh(userdb)
    
    token = jwt.encode({"id":userdb.id},'password_key',algorithm="HS256")
    
    return {'token':token,'user':userdb}





@router.post('/login',status_code=200)
def loginUser(user:LoginUser,db: Session = Depends(get_db)):
    userdb = db.query(User).filter(user.email==User.email).first()
    
    if not userdb:
        raise HTTPException(400,"User does not exist")
    
    if not bcrypt.checkpw(user.password.encode(),userdb.password):
        raise HTTPException(400,'Incorrect Password')
    
    token = jwt.encode({'id':userdb.id},'password_key',algorithm="HS256"
)
    
    return {'token':token,'user':userdb}


# Set Up Profile
@router.post('/setup-profile',status_code=201,)
def setupProfile(profile:ProfileCreate,db:Session = Depends(get_db),user_dict=Depends(auth_middleware)):
    userid = user_dict['uid']
    userProfile = Profile(id=str(uuid.uuid4()),user_id=userid,name=profile.name,location=profile.location,phone=profile.phone,email=profile.email,bio=profile.bio,industry=profile.industry,company_size=profile.company_size,founded_year=profile.founded_year,specialities=profile.specialities,website=profile.website,experience_years=profile.experience_years,job_title=profile.job_title,skills=profile.skills,education=profile.education,resume_url=profile.resume_url)

    db.add(userProfile)
    db.commit()
    db.refresh(userProfile)
    
    return userProfile
        
        
        
@router.get('/')
def getUserData(db:Session=Depends(get_db),user_dict=Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).first()
    
    if not user:
        raise HTTPException(404,'User not found!')
    
    if not user.profile:
        raise HTTPException(404,"Profile Not Found")
    
    return user.profile


@router.get('/user/{profile_id}')
def get_user_uid(profile_id: str, db: Session = Depends(get_db)):
    profile = db.query(Profile).filter(Profile.id == profile_id).first()

    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")

    return {"user_id": profile.user_id}


@router.get("/profile/{user_id}")
def get_profile_id(user_id: str, db: Session = Depends(get_db)):
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()

    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")

    return {"profile_id": profile.id}

