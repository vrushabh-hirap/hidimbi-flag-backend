#!/bin/sh
# ---------------------------------------------------------------------------
# backend_flag/entrypoint.sh — the Render service that gives you the
# FLAG SERVICE URL.
#
# Single process on :8000 (Render routes $PORT here). The internal index is
# deliberately NOT started: HIDIMBI_EXPOSE_INTERNAL defaults to 0 in this
# image, so /internal/gate does not exist on the public service at all.
# ---------------------------------------------------------------------------
set -e

: "${PORT:=8000}"

echo "[*] Flag service starting on :$PORT (internal gate disabled)"

exec uvicorn flag_service:app --host 0.0.0.0 --port "$PORT" --log-level info
