from app import app

def test_root():
    client = app.test_client()
    response = client.get('/')
    assert response.status_code == 200

def test_guess():
    client = app.test_client()
    response = client.get('/guess/42')
    assert response.status_code == 200
