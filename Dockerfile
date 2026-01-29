FROM python:3.10-slim

# Prevent Python cache & speed up logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# System deps (minimal)
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install CPU-only torch FIRST
RUN pip install --no-cache-dir torch \
    --index-url https://download.pytorch.org/whl/cpu

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code (after deps for caching)
COPY . .

# Expose Flask port
EXPOSE 8080

CMD ["python", "app.py"]
