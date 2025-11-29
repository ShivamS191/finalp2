# Base Image
FROM python:3.11-slim

# Environment Variables
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Working Directory
WORKDIR /app

# System Dependencies (Playwright + Chromium)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates curl gnupg unzip fonts-liberation libnss3 libnspr4 \
    libatk1.0-0 libatk-bridge2.0-0 libx11-xcb1 libxcomposite1 libxdamage1 \
    libxrandr2 libxss1 libasound2 libxshmfence1 libgbm1 libglib2.0-0 xvfb \
    && rm -rf /var/lib/apt/lists/*

# Python Dependencies
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Install Playwright + Browsers
RUN pip install playwright
RUN python -m playwright install chromium

# Copy App
COPY . .

# Expose Port (default 3000)
EXPOSE 3000

# Start App (Uses Render PORT or defaults to 3000)
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-3000}"]
