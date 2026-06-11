#!/bin/bash
# Lumentum sunucu dizin iskeleti — YALNIZCA lumentum.cicibyte.com
set -euo pipefail

ROOT="/www/wwwroot/lumentum.cicibyte.com"
EXT="/www/server/panel/vhost/nginx/extension/lumentum.cicibyte.com"

echo "[lumentum] Dizinler oluşturuluyor..."
mkdir -p "$ROOT"/{api,data,logs,scripts,backups,web}
mkdir -p "$EXT"

chown -R www:www "$ROOT"/{api,data,logs,scripts,backups,web} 2>/dev/null || true

echo "[lumentum] Tamamlandı: $ROOT"
