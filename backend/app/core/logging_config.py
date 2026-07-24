import logging
import sys

def setup_logging():
    # Configure root logger
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        handlers=[
            logging.StreamHandler(sys.stdout)
        ]
    )
    
    # Return a configured logger for the app
    logger = logging.getLogger("smart_energy_ai")
    logger.setLevel(logging.INFO)
    return logger

logger = setup_logging()
