# Changelog

All notable changes to the Smart Energy AI project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Phase 1: Enterprise UI/UX**
  - Integrated full Material 3 design system.
  - Added Dark and Light mode toggling using Riverpod.
  - Implemented a responsive navigation shell for Desktop, Tablet, and Mobile.
  - Added micro-animations (`AnimatedCard`).
  - Added professional skeleton loaders for asynchronous operations.
  - Added custom generic empty states.
  - Added core application pages: Profile, Settings, Notifications.
- **Phase 6: Authentication & Security**
  - Integrated Firebase Authentication into the Flutter Frontend (Login Screen, Riverpod Auth State Provider).
  - Configured GoRouter to intercept route access and seamlessly redirect unauthenticated traffic.
  - Implemented JWT token verification in FastAPI backend using `firebase_admin` and `HTTPBearer`.
- **Phase 5: Database Migration**
  - Added PostgreSQL support via `psycopg2-binary`.
  - Refactored `database.py` to conditionally handle SQLite (development) and PostgreSQL (production).
  - Ensured schema tables automatically provision on application startup.
- **Phase 4: Backend Enhancements**
  - Configured `slowapi` rate limiting (10 req/min) on `/copilot/chat` to prevent AI abuse.
  - Added `cachetools.TTLCache` to `/analytics` to improve query latency and reduce DB load.
  - Implemented `LoggingMiddleware` to automatically log request processing times and status codes.
- **Phase 3: Advanced Analytics & Reporting**
  - Integrated `fl_chart` to render interactive time-series Energy and Carbon trend charts.
  - Re-architected `/analytics` screen to use Tab-based navigation for different chart metrics.
  - Implemented dynamic PDF Export functionality utilizing `pdf` and `printing` packages.
  - Updated FastAPI backend to return detailed 24-hour chronological data points for historical analysis.
- **Phase 2: AI Copilot Assistant**
  - Revamped `/copilot` screen to feature a dual-pane layout on Desktop.
  - Added an interactive Chat UI with user and AI message bubbles.
  - Created a FastAPI backend route (`/copilot/chat`) to serve dynamic conversational responses.
  - Implemented actionable suggestions chips within the Chat interface.
  - Managed chat state via Riverpod `Notifier`.

### Changed
- Migrated state management from legacy `StateNotifier` to modern Riverpod `Notifier`.
- Resolved all deprecated `scale` and `withOpacity` warnings.
- Cleaned up obsolete routing code in `app_router.dart`.
- Ignored redundant build artifacts in `.gitignore`.
