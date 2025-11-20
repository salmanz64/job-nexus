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
    userid = user_dict['uid']
    
    newJob = Job(id=str(uuid.uuid4()),title=job.title,description=job.description,requirements=job.requirements,location=job.location,salary_range=job.salary_range,job_type=job.job_type,experience_level=job.experience_level,category=job.category,skills=job.skills,recruiter_id=userid,responsibilities=job.responsibilities)
    
    db.add(newJob)
    db.commit()
    db.refresh(newJob)
    
    return newJob

@router.get('/',status_code=200)
def getJobs(db:Session = Depends(get_db),user_dict=Depends(auth_middleware)):
    userid= user_dict['uid']
    
    allJobs = db.query(Job).filter(Job.recruiter_id==userid).all()
    
    return allJobs
    