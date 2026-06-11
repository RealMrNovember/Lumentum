#!/bin/bash
# Lumentum API kurulumu — tum bagimliliklar YALNIZCA api/deps icinde
set -eu

ROOT="/www/wwwroot/lumentum.cicibyte.com"
API="$ROOT/api"
DEPS="$API/deps"

cd "$API"

echo "[lumentum] Python bagimliliklari: $DEPS"
mkdir -p "$DEPS"
python3 -m pip install --upgrade pip -q
python3 -m pip install -r requirements.txt -t "$DEPS" -q

if [ ! -f .env ]; then
  cp .env.example .env 2>/dev/null || true
  if ! grep -q JWT_SECRET= .env 2>/dev/null; then
    echo "JWT_SECRET=$(openssl rand -hex 32)" >> .env
  fi
  echo "DEBUG=false" >> .env
  echo "LICENSE_MOCK=true" >> .env
fi

mkdir -p "$ROOT/data"
chown -R www:www "$ROOT/data" "$API" "$DEPS" 2>/dev/null || true

# systemd — sistem Python + izole PYTHONPATH
cat > /etc/systemd/system/lumentum-api.service << 'UNIT'
[Unit]
Description=Lumentum Shared API (FastAPI)
After=network.target

[Service]
Type=simple
User=www
Group=www
WorkingDirectory=/www/wwwroot/lumentum.cicibyte.com/api
Environment=PYTHONPATH=/www/wwwroot/lumentum.cicibyte.com/api/deps
EnvironmentFile=/www/wwwroot/lumentum.cicibyte.com/api/.env
ExecStart=/usr/bin/python3 -m uvicorn main:app --host 127.0.0.1 --port 18765
Restart=on-failure
RestartSec=5
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable lumentum-api
systemctl restart lumentum-api

# nginx extension (yalnizca lumentum vhost)
mkdir -p /www/server/panel/vhost/nginx/extension/lumentum.cicibyte.com
cp "$ROOT/scripts/lumentum-api.conf" \
  /www/server/panel/vhost/nginx/extension/lumentum.cicibyte.com/api.conf

/www/server/nginx/sbin/nginx -t && /www/server/nginx/sbin/nginx -s reload

echo "[lumentum] health:"
sleep 1
curl -sf http://127.0.0.1:18765/api/health || (journalctl -u lumentum-api -n 20 --no-pager; exit 1)
echo ""
