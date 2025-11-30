from datetime import datetime
from typing import Optional
from fastapi import APIRouter,Depends,HTTPException
from pydantic_schemas.usercreate import CreateUser
from sqlalchemy.orm import Session
from database import get_db
from models.user import User
from middlewares.auth_middleware import auth_middleware
from models.profile import Profile
from pydantic_schemas.application_create import ApplicationCreate
from models.job import Job
from models.application import Application
import uuid
from sqlalchemy.orm import joinedload

from pydantic_schemas.update_application import UpdateApplication

router = APIRouter()

@router.post('/create',status_code=201)
def createApplication(application:ApplicationCreate,db:Session = Depends(get_db),user_dict=Depends(auth_middleware)):
    user_id = user_dict['uid']
    
    job = db.query(Job).filter(Job.id == application.job_id).first()
    
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    
    profile = db.query(Profile).filter(Profile.user_id==user_id).first()
    
    if not profile:
        raise HTTPException(status_code=404,detail="Profile Not Found")
    
    
    existing_application = db.query(Application).filter(Application.job_id==application.job_id,Application.candidate_id == profile.id).first()
    
    if existing_application:
        raise HTTPException(status_code=400, detail="You have already applied to this job")
    
    
    new_application = Application(
        id=str(uuid.uuid4()),
        job_id=application.job_id,
        candidate_id=profile.id,
        resume_url=application.resume_url
    )
    
    job.application_count +=1
    
    db.add(new_application)
    db.commit()
    db.refresh(new_application)
    
    return new_application

@router.get('/recruiter/')
def getApplications(
    status: Optional[str] = None,
    search: Optional[str] = None,
    job_id:Optional[str] = None,
    db: Session = Depends(get_db), user_dict = Depends(auth_middleware)):
    user_id = user_dict['uid']
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404,detail="Profile Not Found")
    
    query = (
        db.query(Application)
        .join(Job)
        .options(joinedload(Application.job), joinedload(Application.profile))
        .filter(Job.recruiter_id == profile.id)

    )
    if status:
        query = query.filter(Application.status == status)
    if search:
        query = query.filter(Job.title.ilike(f"%{search}%"))

    if job_id:
        query = query.filter(Application.job_id == job_id)
    
    applications = query.all()
    
    return applications

@router.get('/candidate/')
def getMyApplications(db: Session = Depends(get_db), user_dict = Depends(auth_middleware)):
    user_id = user_dict['uid']
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404,detail="Profile Not Found")
    
    all_applications = db.query(Application).join(Job).options(joinedload(Application.job).joinedload(Job.recruiter)).filter(Application.candidate_id==profile.id).all()
    
    return all_applications

@router.patch('/update-status')
def updateApplicationStatus(application:UpdateApplication,db: Session = Depends(get_db), user_dict = Depends(auth_middleware)):
    user_id = user_dict['uid']
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404,detail="Profile Not Found")
    
    targetApplication = db.query(Application).filter(Application.id == application.application_id).first()
    
    if not targetApplication:
        raise HTTPException(status_code=404,detail="Application Not found")
    
    
    if application.status not in ["applied","reviewed","shortlisted", "accepted", "rejected"]:
        raise HTTPException(status_code=400, detail="Invalid status value")

    
    targetApplication.status = application.status
    targetApplication.updated_at = datetime.utcnow()

    
    db.commit()
    db.refresh(targetApplication)
    
    return {
        
        "message":"Update Successful",
        "id":targetApplication.id,
        "status":application.status
        
    }
    
    
    