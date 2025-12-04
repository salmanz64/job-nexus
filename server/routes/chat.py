from fastapi import APIRouter, HTTPException, WebSocket, Depends
from sqlalchemy import desc, func
from sqlalchemy.orm import Session
from database import get_db
from models.message import Message
from models.profile import Profile
from web_sockets.ws_manager import manager

router = APIRouter()

# ------------------------------ WEBSOCKET HANDLER ------------------------------ #

@router.websocket("/ws/chat/{user_id}")
async def chat(websocket: WebSocket, user_id: str):
    """Handles connection & real-time messaging for a user."""
    db: Session = next(get_db())
    
    # Get profile using user_id
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile Not Found")

    # Connect websocket using PROFILE ID
    await manager.connect(profile.id, websocket)

    try:
        while True:
            data = await websocket.receive_json()

            sender_id: str = profile.id            # Always profile ID
            receiver_id: str = data["receiver_id"] # Must also be profile ID
            message_text: str = data["message"]

            # Save message to DB
            msg = Message(
                sender_id=sender_id,
                receiver_id=receiver_id,
                content=message_text
            )
            db.add(msg)
            db.commit()
            db.refresh(msg)

            # Deliver to receiver (if connected)
            await manager.send_personal(receiver_id, {
                "id": str(msg.id),
                "senderId": sender_id,
                "receiverId": receiver_id,
                "message": message_text,
                "timestamp": msg.timestamp.isoformat(),
                "isDelivered": True,
                "isSeen": False
            })

    except Exception as e:
        print(f"WebSocket error: {e}")

    finally:
        manager.disconnect(profile.id)



# ------------------------------ CHAT PREVIEW LIST ------------------------------ #

@router.get("/chat/preview/{user_id}")
def get_chat_previews(user_id: str, db: Session = Depends(get_db)):
    """Returns last message & unread count per conversation."""
    
    profile = db.query(Profile).filter(Profile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile Not Found")

    subquery = (
        db.query(
            func.least(Message.sender_id, Message.receiver_id).label("u1"),
            func.greatest(Message.sender_id, Message.receiver_id).label("u2"),
            func.max(Message.timestamp).label("last_time"),
        )
        .group_by("u1", "u2")
        .subquery()
    )

    latest_messages = (
        db.query(Message)
        .join(
            subquery,
            (func.least(Message.sender_id, Message.receiver_id) == subquery.c.u1)
            & (func.greatest(Message.sender_id, Message.receiver_id) == subquery.c.u2)
            & (Message.timestamp == subquery.c.last_time)
        )
        .order_by(desc(Message.timestamp))
        .all()
    )

    previews = []

    for msg in latest_messages:

        # Only include conversations involving this profile_id
        if profile.id not in [msg.sender_id, msg.receiver_id]:
            continue

        # Determine other participant (profile_id)
        chat_partner_id = msg.receiver_id if msg.sender_id == profile.id else msg.sender_id

        partner_profile = db.query(Profile).filter(Profile.id == chat_partner_id).first()

        unread_count = (
            db.query(Message)
            .filter(
                Message.sender_id == chat_partner_id,
                Message.receiver_id == profile.id,
                Message.is_read == False
            )
            .count()
        )


        previews.append({
            "user_id": partner_profile.user_id,  # Return user_id so frontend works
            "profile_id": partner_profile.id,
            "name": partner_profile.name,
            "profile_image": partner_profile.profile_image_url,
            "last_message": msg.content,
            "timestamp": msg.timestamp.isoformat(),
            "unread_count": unread_count,
        })

    return previews 



# ------------------------------ MESSAGE HISTORY ------------------------------ #

@router.get("/messages/{user1}/{user2}")
def get_messages(user1: str, user2: str, db: Session = Depends(get_db)):
    """Returns message history between two PROFILE IDs."""

    # Mark messages sent to user1 as read
    (
        db.query(Message)
        .filter(
            Message.sender_id == user2,
            Message.receiver_id == user1,
            Message.is_read == False
        )
        .update({Message.is_read: True})
    )
    db.commit()

    # Fetch conversation
    messages = (
        db.query(Message)
        .filter(
            ((Message.sender_id == user1) & (Message.receiver_id == user2)) |
            ((Message.sender_id == user2) & (Message.receiver_id == user1))
        )
        .order_by(Message.timestamp.asc())
        .all()
    )

    return [
        {
            "id": str(msg.id),
            "senderId": msg.sender_id,
            "receiverId": msg.receiver_id,
            "message": msg.content,
            "timestamp": msg.timestamp.isoformat(),
            "isDelivered": True,
            "isSeen": msg.is_read,
        }
        for msg in messages
    ]
