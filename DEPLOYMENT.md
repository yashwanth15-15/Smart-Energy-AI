# Smart Energy AI - Deployment Guide

## Frontend (Firebase Hosting)
The frontend is built with Flutter Web and deployed seamlessly via Firebase Hosting.

### CI/CD Deployment
A GitHub Actions workflow automatically builds and deploys the frontend upon pushing to the `main` branch. 
Ensure the repository contains the `FIREBASE_SERVICE_ACCOUNT` secret.

### Manual Deployment
```bash
cd frontend
flutter build web --release
firebase deploy --only hosting
```

## Backend (Render)
The backend is a FastAPI application hosted on Render.

### CI/CD Deployment
Render is connected to the GitHub repository and auto-deploys upon push. 

### Manual Setup
1. Create a Web Service on Render.
2. Build Command: `pip install -r requirements.txt`
3. Start Command: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
4. Environment Variables:
   - `DATABASE_URL`: Your PostgreSQL Connection String
   - `CORS_ORIGINS`: Allowed origins (e.g., your Firebase URL)
