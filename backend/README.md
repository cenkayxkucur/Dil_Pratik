# Dil Pratik Backend

This is the backend service for the Dil Pratik application, built with FastAPI.

## Setup

1. Create a virtual environment:
```bash
python -m venv venv
```

2. Activate the virtual environment:
- Windows:
```bash
.\venv\Scripts\activate
```
- Linux/Mac:
```bash
source venv/bin/activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Create a `.env` file in the root directory with the following variables:
```
DATABASE_URL=postgresql://user:password@localhost:5432/dilpratik
SECRET_KEY=your-secret-key
OPENAI_API_KEY=your-openai-api-key
FIREBASE_CREDENTIALS=path/to/firebase-credentials.json
```

5. Run the application:
```bash
uvicorn app.main:app --reload
```

The API will be available at `http://localhost:8000`

## API Documentation

Once the server is running, you can access:
- Interactive API documentation: `http://localhost:8000/docs`
- Alternative API documentation: `http://localhost:8000/redoc` 