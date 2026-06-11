<?php

require '/www/wwwroot/license.cicibyte.com/vendor/autoload.php';
$app = require '/www/wwwroot/license.cicibyte.com/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$user = App\Models\User::query()->first();
if (! $user) {
    echo "NO_USER\n";
    exit(1);
}

Illuminate\Support\Facades\Auth::login($user);
$request = Illuminate\Http\Request::create('/admin', 'GET');
$response = $app->handle($request);
$html = $response->getContent();

echo 'STATUS='.$response->getStatusCode().PHP_EOL;
echo 'GROUPS='.substr_count($html, 'fi-sidebar-group').PHP_EOL;
echo 'APPLICATIONS='.(str_contains($html, 'Applications') ? 'yes' : 'no').PHP_EOL;
echo 'LICENSES='.(str_contains($html, 'Licenses') ? 'yes' : 'no').PHP_EOL;
echo 'CLIENTS='.(str_contains($html, 'Clients') ? 'yes' : 'no').PHP_EOL;
echo 'SIDEBAR_FIX_CSS='.(str_contains($html, 'filament-sidebar-fix') ? 'yes' : 'no').PHP_EOL;
echo 'HEAD_CLEAR='.(str_contains($html, 'removeItem("collapsedGroups")') ? 'yes' : 'no').PHP_EOL;

if (preg_match_all('/data-group-label="([^"]*)"/', $html, $m)) {
    echo 'LABELS='.implode('|', $m[1]).PHP_EOL;
}

if (preg_match_all('/fi-sidebar-group-items[^>]*style="([^"]*)"/', $html, $styles)) {
    echo 'HIDDEN_STYLES='.implode('|', $styles[1]).PHP_EOL;
}
