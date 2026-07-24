from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import firebase_admin
from firebase_admin import auth

import os
import json
from firebase_admin import credentials

if not firebase_admin._apps:
    cert_env = os.getenv("FIREBASE_SERVICE_ACCOUNT_JSON")
    if cert_env:
        cert_dict = json.loads(cert_env)
        cred = credentials.Certificate(cert_dict)
        firebase_admin.initialize_app(cred, options={"projectId": "smart-energy-ai-3ff26"})
    else:
        firebase_admin.initialize_app(options={"projectId": "smart-energy-ai-3ff26"})

security = HTTPBearer()

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials

    import logging
    logging.info("Authorization header received")
    logging.info(f"Token length: {len(token)}")

    try:
        decoded_token = auth.verify_id_token(token)
        logging.info(f"Verified UID: {decoded_token.get('uid')}")
        return decoded_token

    except Exception as e:
        import traceback
        logging.exception("Firebase token verification failed")
        raise HTTPException(
            status_code=401,
            detail=str(e),
        )
