# Smart Energy AI - Release Candidate 1 (v1.0.0)

## Overview
Smart Energy AI is an enterprise-grade AI Smart Energy Management Platform designed to optimize, monitor, and predict energy consumption for modern campuses. Built with a scalable architecture, it integrates a Flutter Web frontend with a powerful FastAPI backend, secured by Firebase Authentication and powered by machine learning algorithms.

## Features
- **Dashboard**: Real-time energy monitoring with live data integration.
- **AI Copilot**: Intelligent assistant for energy insights, utilizing rate limiting and advanced context caching.
- **Analytics Engine**: Interactive data visualization powered by `fl_chart`.
- **Predictions**: Machine learning pipeline for load forecasting (XGBoost/Scikit-Learn).
- **Enterprise Security**: Firebase Authentication and JWT middleware.
- **Scalable Backend**: FastAPI connected to a dynamic PostgreSQL/SQLite database.

## Quick Links
- [Architecture Guide](ARCHITECTURE.md)
- [Database ER Diagram](ER_DIAGRAM.md)
- [API Documentation](API_DOCS.md)
- [Deployment Guide](DEPLOYMENT.md)
- [Developer Guide](DEVELOPER_GUIDE.md)
- [User Guide](USER_GUIDE.md)
- [Changelog](CHANGELOG.md)

## Tech Stack
- **Frontend**: Flutter Web (Dart), Riverpod, GoRouter, Material 3
- **Backend**: FastAPI (Python), SQLAlchemy, PostgreSQL, Firebase Admin
- **Machine Learning**: Scikit-Learn, XGBoost, Pandas
- **Infrastructure**: Firebase Hosting (Frontend), Render (Backend), GitHub Actions (CI/CD)
