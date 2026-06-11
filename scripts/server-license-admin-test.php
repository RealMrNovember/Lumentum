<?php

$root = '/www/wwwroot/license.cicibyte.com';
require $root . '/vendor/autoload.php';
$app = require $root . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$user = App\Models\User::query()->first();
if (! $user) {
    echo "NO_USER\n";
    exit(1);
}

auth()->login($user);

try {
    $request = Illuminate\Http\Request::create('/admin', 'GET');
    $response = $app->handle($request);
    echo 'STATUS=' . $response->getStatusCode() . PHP_EOL;
    $body = $response->getContent();
    if (str_contains($body, '500 | Server Error') || str_contains($body, 'SERVER ERROR')) {
        echo "BODY_HAS_500_PAGE\n";
    }
    if (str_contains($body, 'fi-sidebar-item-label')) {
        preg_match_all('/fi-sidebar-item-label[^>]*>\s*([^<]+)/', $body, $items);
        echo 'ITEMS=' . implode(' | ', array_map('trim', $items[1] ?? [])) . PHP_EOL;
    }
    if ($response->getStatusCode() >= 500) {
        echo substr($body, 0, 500) . PHP_EOL;
    }
} catch (Throwable $e) {
    echo 'EXCEPTION=' . $e->getMessage() . PHP_EOL;
    echo $e->getFile() . ':' . $e->getLine() . PHP_EOL;
}
