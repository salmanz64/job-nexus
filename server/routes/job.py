from fastapi import APIRouter,Depends,HTTPException
from sqlalchemy import not_
from sqlalchemy.orm import Session
from database import get_db
from models.user import User
from middlewares.auth_middleware import auth_middleware
from models.profile import Profile
from pydantic_schemas.jobcreate import JobCreate
from models.job import Job
import uuid

from models.application import Application




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
from sqlalchemy.orm import joinedload

@router.get('/all',status_code=200)
def getAllJobs(db:Session = Depends(get_db), user_dict=Depends(auth_middleware)):
    user_id = user_dict['uid']

    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile Not Found")
    
    subquery = db.query(Application.job_id).filter(Application.candidate_id == profile.id)

    allJobs = (
        db.query(Job)
        .options(joinedload(Job.recruiter))    # <---- loads recruiter profile
        .filter(~Job.id.in_(subquery))         # "not applied jobs"
        .all()
    )

    return allJobs



@router.get('/hired/total', status_code=200)
def get_total_hired(db: Session = Depends(get_db), user_dict=Depends(auth_middleware)):
    user_id = user_dict['uid']
    
    # Get recruiter profile
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile Not Found")
    
    # Count applications with status "hired" linked to recruiter's jobs
    total_hired = (
        db.query(Application)
        .join(Job, Application.job_id == Job.id)
        .filter(Job.recruiter_id == profile.id, Application.status == "hired")
        .count()
    )
    
    return {"total_hired": total_hired}



@router.get('/active', status_code=200)
def getActiveJobs(db: Session = Depends(get_db), user_dict=Depends(auth_middleware)):
    user_id = user_dict['uid']
    
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile Not Found")

    active_jobs = db.query(Job).filter(
        Job.recruiter_id == profile.id,
        Job.status == "active"
    ).all()

    return active_jobs

@router.delete('/delete/{job_id}', status_code=200)
def deleteJob(job_id: str, db: Session = Depends(get_db), user_dict=Depends(auth_middleware)):
    user_id = user_dict['uid']

    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile Not Found")

    job = db.query(Job).filter(Job.id == job_id, Job.recruiter_id == profile.id).first()

    if not job:
        raise HTTPException(status_code=404, detail="Job not found or not authorized")

    db.delete(job)
    db.commit()

    return {"message": "Job deleted successfully", "job_id": job_id}

    