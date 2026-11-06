FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/app.py .
CMD ["sh", "-c", "gunicorn -b 0.0.0.0:${BACKEND_PORT} --timeout 120 app:app"]
