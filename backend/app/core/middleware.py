from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
import time
from app.core.logging_config import logger

class LoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        start_time = time.time()
        
        # Log request
        logger.info(f"Incoming Request: {request.method} {request.url.path}")
        
        try:
            response = await call_next(request)
            process_time = (time.time() - start_time) * 1000
            
            # Log response
            logger.info(f"Completed Request: {request.method} {request.url.path} - Status: {response.status_code} - Time: {process_time:.2f}ms")
            
            return response
        except Exception as e:
            process_time = (time.time() - start_time) * 1000
            logger.error(f"Failed Request: {request.method} {request.url.path} - Error: {str(e)} - Time: {process_time:.2f}ms")
            raise e
