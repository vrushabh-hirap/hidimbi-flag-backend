# ---------------------------------------------------------------------------
# backend_flag/Dockerfile — the Render service that gives you the
# FLAG SERVICE URL.
#
# Render settings:
#   Language:                     Docker
#   Dockerfile Path:              backend_flag/Dockerfile
#   Docker Build Context Dir:     backend_flag
#   Health Check Path:            /healthz
#   Environment: HIDIMBI_ROLE=flagger, HIDIMBI_EXPOSE_INTERNAL=0,
#               plus the secrets (see RENDER_DEPLOY.md)
#
# NOTE what is absent: server.py. This container cannot serve the Lake API,
# so the flag service and the Lake API are genuinely different processes,
# exactly like the docker-compose topology.
# ---------------------------------------------------------------------------
FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=8000 \
    HIDIMBI_ROLE=flagger \
    HIDIMBI_EXPOSE_INTERNAL=0 \
    CONFIG_PATH=/app/config.json

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
      curl postgresql-client \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY flag_service.py ./
COPY config.json ./
COPY private_key.pem public_key.pem ./
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
