#!/bin/bash
set -euo pipefail
BODY='{"app_code":"lumentum","hwid":"web-test-12345678","email":"mozkarci1991@gmail.com","platform":"web"}'
echo "=== POST check (verbose) ==="
curl -sS -v -X POST "https://license.cicibyte.com/api/v1/license/check" \
  -H "Content-Type: application/json" \
  -H "X-Api-Key: Cicibyte_X92kLpQ84mNz_2026!" \
  -d "$BODY" 2>&1 | tail -30

echo ""
echo "=== POST trial ==="
curl -sS -w "\nHTTP:%{http_code}\n" -X POST "https://license.cicibyte.com/api/v1/license/trial" \
  -H "Content-Type: application/json" \
  -H "X-Api-Key: Cicibyte_X92kLpQ84mNz_2026!" \
  -d "$BODY"
