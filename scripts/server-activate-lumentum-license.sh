#!/bin/bash
set -euo pipefail
DB_PASS=$(grep "^DB_PASSWORD=" /www/wwwroot/license.cicibyte.com/.env | cut -d= -f2-)
mysql -u license_cicibyte -p"$DB_PASS" sql_license_cicibyte -e "SHOW COLUMNS FROM applications;"
mysql -u license_cicibyte -p"$DB_PASS" sql_license_cicibyte -e "SELECT * FROM applications LIMIT 5;"
