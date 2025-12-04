from fastapi import APIRouter, Form, File, UploadFile, Depends, HTTPException
import json
from sqlalchemy.orm import Session
from cloudinary.uploader import upload as cloud_upload
import uuid

from database import get_db
from middlewares.auth_middleware import auth_middleware
from pydantic_schemas.profile_create import ProfileCreate
from models.profile import Profile


router = APIRouter()


@router.post("/setup-new", status_code=201)
async def setup_profile(
    profile_data: str = Form(...),      # JSON comes as text
    profile_image: UploadFile = File(None),
    db: Session = Depends(get_db),
    user_dict=Depends(auth_middleware),
):
    try:
        data = json.loads(profile_data)   # Convert string → dict
        profile = ProfileCreate(**data)   # Validate using pydantic
    except Exception as e:
        raise HTTPException(status_code=422, detail=f"Invalid profile JSON: {e}")

    user_id = user_dict["uid"]

    # ---- Upload image if exists ----
    image_url = None
    if profile_image:
        upload_result = cloud_upload(profile_image.file, folder="profile_pictures")
        image_url = upload_result.get("secure_url")

    # ---- Create DB model ----
    new_profile = Profile(
        id=str(uuid.uuid4()),
        user_id=user_id,
        profile_image_url=image_url,
        name=profile.name,
        location=profile.location,
        phone=profile.phone,
        email=profile.email,
        bio=profile.bio,
        industry=profile.industry,
        company_size=profile.company_size,
        founded_year=profile.founded_year,
        specialities=profile.specialities,
        website=profile.website,
        experience_years=profile.experience_years,
        job_title=profile.job_title,
        skills=profile.skills,
        education=profile.education,
        resume_url=profile.resume_url,
    )

    db.add(new_profile)
    db.commit()
    db.refresh(new_profile)

    return new_profile
