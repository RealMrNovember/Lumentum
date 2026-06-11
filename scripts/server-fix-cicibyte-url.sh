#!/bin/bash
set -euo pipefail
FILE=/www/wwwroot/cicibyte.com/config/ecosystem.php
perl -pi -e "s/'#lumentum'/'https:\/\/lumentum.cicibyte.com'/" "$FILE"
grep -n lumentum "$FILE"
