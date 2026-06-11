<?php

require '/www/wwwroot/license.cicibyte.com/vendor/autoload.php';
$app = require '/www/wwwroot/license.cicibyte.com/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$email = 'mozkarci1991@gmail.com';
$client = App\Models\Client::query()->where('email', $email)->first();
if (! $client) {
    echo "NO_CLIENT\n";
    exit(1);
}

foreach ($client->licenses as $license) {
    $count = $license->devices()->count();
    $license->devices()->delete();
    echo "Cleared {$count} device(s) from license {$license->license_key}\n";
}

echo "DONE client={$client->id}\n";
