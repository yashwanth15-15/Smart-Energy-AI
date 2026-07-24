# Smart Energy AI

Smart Energy AI is a full-stack platform designed to predict and monitor energy usage across multiple buildings using Machine Learning.

## Architecture

- **Frontend**: Flutter Web, utilizing Riverpod for state management and `fl_chart` for data visualization.
- **Backend**: FastAPI, connected to a database (SQLite for dev, PostgreSQL for prod).
- **Machine Learning**: XGBoost model, predicting hourly energy demand based on temperature, occupancy, and HVAC status.

### Folder Structure
- `/backend`: Python FastAPI application and ML training scripts.
- `/frontend`: Dart/Flutter web application.
- `render.yaml`: Infrastructure as Code for deploying to Render.

## Features

- **Live Dashboard**: View current energy load and active alerts.
- **ML Predictions**: 24-hour predictive load curve based on XGBoost inference.
- **Analytics**: Historical comparisons and scenario modeling.

## Screenshots

*(Placeholder for dashboard screenshot)*
`![Dashboard](/docs/dashboard.png)`

*(Placeholder for prediction chart screenshot)*
`![Prediction Chart](/docs/prediction.png)`

## Installation (Local Development)

### Backend
1. `cd backend`
2. `python -m venv .venv`
3. Activate virtual environment (`.venv\Scripts\activate` on Windows, `source .venv/bin/activate` on Mac/Linux)
4. `pip install -r requirements.txt`
5. `python scripts/train_model.py` (To generate `model.pkl`)
6. `cp .env.example .env` (Adjust as needed)
7. `uvicorn app.main:app --reload`

### Frontend
1. `cd frontend`
2. `flutter pub get`
4. `flutter run -d chrome --dart-define=API_URL=http://localhost:8000`

## Deployment

### Render (Backend & Database)
This repository is configured for one-click deployment on Render.
1. Connect your GitHub repository to Render.
2. Render will automatically detect `render.yaml` and provision:
   - A PostgreSQL Database
   - A FastAPI Web Service using Gunicorn

### Firebase Hosting (Frontend)
1. Ensure `firebase-tools` is installed globally (`npm install -g firebase-tools`).
2. Run `firebase login`.
3. Build the frontend for production:
   ```bash
   cd frontend
   flutter build web --release
   ```
   *(Note: The production build automatically defaults to `https://smart-energy-ai-ivwu.onrender.com`. If deploying to a different backend, you can override this with `--dart-define=API_URL=...`)*
4. Deploy using `firebase deploy --only hosting` or upload the `build/web/` folder to Vercel/Netlify.

## API Documentation
Once the backend is running locally, visit `http://127.0.0.1:8000/docs` to view the interactive Swagger API documentation.
