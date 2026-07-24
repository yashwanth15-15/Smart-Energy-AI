import firebase_admin
from firebase_admin import auth

def test():
    if not firebase_admin._apps:
        firebase_admin.initialize_app()
    try:
        auth.verify_id_token("fake_token")
    except Exception as e:
        print(f"Exception: {type(e).__name__} - {e}")

if __name__ == "__main__":
    test()
