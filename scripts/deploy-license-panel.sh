#!/bin/bash
set -euo pipefail
REMOTE=/www/wwwroot/license.cicibyte.com
PHP=/www/server/php/83/bin/php

cd "$(dirname "$0")/../.."
SRC=license-cicibyte

scp -r "$SRC/app/Filament" root@31.40.199.47:"$REMOTE/app/"
scp -r "$SRC/app/Providers/Filament" root@31.40.199.47:"$REMOTE/app/Providers/"
scp "$SRC/app/Providers/Filament/AdminPanelProvider.php" root@31.40.199.47:"$REMOTE/app/Providers/Filament/"
scp -r "$SRC/resources/views/vendor/filament-panels" root@31.40.199.47:"$REMOTE/resources/views/vendor/"
scp -r "$SRC/app/Models" root@31.40.199.47:"$REMOTE/app/"
scp "$SRC/app/Services/LicenseService.php" root@31.40.199.47:"$REMOTE/app/Services/"
scp "$SRC/database/migrations/2026_06_11_220000_add_starts_on_activation_to_licenses_table.php" root@31.40.199.47:"$REMOTE/database/migrations/"
scp "$SRC/lang/tr.json" "$SRC/lang/en.json" root@31.40.199.47:"$REMOTE/lang/"

ssh root@31.40.199.47 "cd $REMOTE && \
  chown -R www:www app/Filament app/Providers/Filament resources/views/vendor storage bootstrap/cache && \
  find app/Filament app/Providers/Filament resources/views/vendor -type d -exec chmod 755 {} \; && \
  find app/Filament app/Providers/Filament resources/views/vendor -type f -exec chmod 644 {} \; && \
  find storage bootstrap/cache -type d -exec chmod 775 {} \; && \
  find storage bootstrap/cache -type f -exec chmod 664 {} \; && \
  $PHP artisan migrate --force && $PHP artisan optimize:clear"

echo "License panel deploy OK"
