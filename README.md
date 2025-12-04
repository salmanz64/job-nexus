<div align="center">
  
# 🚀 Job Nexus  
### A Modern Full-Stack Job Platform Built for Real-World Hiring

#### 🔍 Search. 🧑‍💼 Apply. 💬 Chat. 🚀 Hire.

---

📸 **Preview**

<table>
  <tr>
    <th>Home Screen</th>
    <th>Job Listing</th>
    <th>Chat System</th>
  </tr>
  <tr>
    <td><img src="./screenshots/client_home_screen.png" width="260"/></td>
    <td><img src="./screenshots/jobs.png" width="260"/></td>
    <td><img src="./screenshots/chat.png" width="260"/></td>
  </tr>
</table>


🎬 **Demo Video (Optional):**  
👉 https://youtu.be/your-video-link

---

</div>

<br>

## 🛠️ Overview

**Job Nexus** is a full-stack job portal where **recruiters can create and manage job postings**, and **candidates can apply, track status, and communicate in real time**.  
Built with a **scalable, enterprise-ready architecture**, it demonstrates modern app design with secure authentication, reactive UI, persistent sessions, and WebSocket-powered live messaging.

This project showcases:

- 🔧 Full-stack engineering  
- 📱 Mobile app architecture (MVVM + Riverpod)  
- 🌐 REST API development  
- 💬 WebSocket real-time communication  
- 🗄️ Database design and normalization  
- 🧩 Clean UI/UX and reusable components  

---

## 🧰 Tech Stack

| Category | Technology |
|---------|------------|
| **Frontend** | Flutter, Dart, Riverpod, SharedPreferences, MVVM |
| **Backend** | FastAPI, Python, SQLAlchemy, Pydantic, WebSockets, JWT Auth |
| **Database** | PostgreSQL + SQLAlchemy ORM |
| **Real-Time Messaging** | WebSockets |
| **State Persistence** | SharedPreferences (Flutter) |
| **Deployment (Planned)** | Docker, Nginx, Railway/Render, Supabase/AWS RDS |

---

## ✨ Core Features

### 🔐 Authentication & Security
- JWT-based login & session protection  
- Role management: **Recruiter** / **Candidate**
- Persistent login using SharedPreferences  

### 🧑‍💼 Recruiter Portal
- Create, publish, update and delete job posts  
- View candidate applications  
- Approve / Reject / Pending status workflows  
- Recruiter dashboard for analytics  
- Real-time chat with applicants  

### 🧑‍💻 Candidate Portal
- Search and filter jobs by category, salary, and keywords  
- View job details & company profile  
- Apply with one click  
- Track application history and status  
- Real-time chat with recruiters  

### 💬 WebSocket Chat System
- Real-time messaging  
- Seen/Delivered state (planned)  
- Timestamp formatting using `timeago`  
- Messages linked with user and job context  

---

## 📱 App Architecture — Flutter

- **MVVM Pattern**  
- **Riverpod State Management**
- Clean modules + Feature-first folder structure  
- Reusable UI widgets & components  
- API abstraction with repository layer

