<?php

require '/www/wwwroot/license.cicibyte.com/vendor/autoload.php';
$app = require '/www/wwwroot/license.cicibyte.com/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$email = 'mozkarci1991@gmail.com';
$clients = App\Models\Client::query()->where('email', $email)->with('licenses.application')->get();
echo "CLIENTS=" . $clients->count() . PHP_EOL;
foreach ($clients as $client) {
    echo "Client #{$client->id} {$client->email} licenses=" . $client->licenses->count() . PHP_EOL;
    foreach ($client->licenses as $license) {
        $appName = $license->application?->name ?? '?';
        echo "  - {$license->license_key} app={$appName} status={$license->status->value}" . PHP_EOL;
    }
}
