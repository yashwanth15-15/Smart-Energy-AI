# Smart Energy AI - API Documentation

The backend exposes a highly robust REST API via FastAPI.

## Authentication
Most endpoints require a valid Firebase ID Token passed in the `Authorization` header.
`Authorization: Bearer <ID_TOKEN>`

## Endpoints
### `GET /health`
- **Description**: Returns the system status and ML model loaded boolean.
- **Auth Required**: False

### `GET /dashboard/summary`
- **Description**: Returns top-level aggregated KPIs (energy consumption, anomalies, etc).
- **Auth Required**: True

### `GET /analytics/data`
- **Description**: Returns cached timeseries analytical data.
- **Auth Required**: True

### `POST /copilot/chat`
- **Description**: Conversational AI interface for system insights. Rate limited.
- **Auth Required**: True
- **Payload**: `{"message": "string"}`

### `POST /prediction/predict`
- **Description**: Feeds realtime sensor parameters to the XGBoost model to predict energy consumption.
- **Auth Required**: True
- **Payload**: `{"features": [...]}`

*For a complete, interactive list of schemas, parameters, and responses, please visit the live Swagger documentation at `https://smart-energy-ai-ivwu.onrender.com/docs`.*
