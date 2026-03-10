FROM python:3.12

WORKDIR /app

# Copy requirements first (better caching)
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the project
COPY . .

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]