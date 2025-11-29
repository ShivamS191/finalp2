FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=3000

WORKDIR /app

# System deps (keep what you need for playwright)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates curl gnupg unzip fonts-liberation libnss3 libnspr4 \
    libatk1.0-0 libatk-bridge2.0-0 libx11-xcb1 libxcomposite1 libxdamage1 \
    libxrandr2 libxss1 libasound2 libxshmfence1 libgbm1 libglib2.0-0 xvfb \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Playwright + browsers (if you actually use it)
RUN pip install playwright
RUN python -m playwright install chromium

COPY . .

EXPOSE 3000

# Use python -m uvicorn (avoids missing console script) and expand $PORT via sh -c
CMD ["sh", "-c", "exec python -m uvicorn main:app --host 0.0.0.0 --port $PORT"]
