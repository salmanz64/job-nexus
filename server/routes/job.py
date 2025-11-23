from fastapi import APIRouter,Depends,HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models.user import User
from middlewares.auth_middleware import auth_middleware
from models.profile import Profile
from pydantic_schemas.jobcreate import JobCreate
from models.job import Job
import uuid




router = APIRouter()

@router.post('/create',status_code=201)
def createJob(job:JobCreate,db:Session = Depends(get_db),user_dict=Depends(auth_middleware)):
    user_id = user_dict['uid']
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404,detail="Profile Not Found")
    
    newJob = Job(id=str(uuid.uuid4()),title=job.title,description=job.description,requirements=job.requirements,location=job.location,salary_range=job.salary_range,job_type=job.job_type,experience_level=job.experience_level,category=job.category,skills=job.skills,recruiter_id=profile.id,responsibilities=job.responsibilities)
    
    db.add(newJob)
    db.commit()
    db.refresh(newJob)
    
    return newJob

@router.get('/',status_code=200)
def getRecruiterJobs(db:Session = Depends(get_db),user_dict=Depends(auth_middleware)):
    user_id = user_dict['uid']
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404,detail="Profile Not Found")
    
    allJobs = db.query(Job).filter(Job.recruiter_id==profile.id).all()
    
    return allJobs

@router.get('/all',status_code=200)
def getAllJobs(db:Session = Depends(get_db),user_dict=Depends(auth_middleware)):
    
    allJobs = db.query(Job).all()
    
    return allJobs
    