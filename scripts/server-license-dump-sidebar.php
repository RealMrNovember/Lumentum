<?php

require '/www/wwwroot/license.cicibyte.com/vendor/autoload.php';
$app = require '/www/wwwroot/license.cicibyte.com/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

Illuminate\Support\Facades\Auth::login(App\Models\User::first());
$html = $app->handle(Illuminate\Http\Request::create('/admin', 'GET'))->getContent();

if (preg_match('/<ul class="fi-sidebar-nav-groups.*?<\/ul>/s', $html, $m)) {
    file_put_contents('/tmp/sidebar-nav.html', $m[0]);
    echo 'WROTE '.strlen($m[0]).' bytes'.PHP_EOL;
} else {
    echo 'NO_MATCH'.PHP_EOL;
}

preg_match_all('/<li[^>]*data-group-label="([^"]*)"[^>]*>/', $html, $labels);
echo 'GROUPS: '.implode(', ', $labels[1] ?? []).PHP_EOL;

preg_match_all('/fi-sidebar-item[^>]*>.*?<span[^>]*>([^<]+)</s', $html, $items);
echo 'ITEMS: '.implode(', ', array_slice($items[1] ?? [], 0, 10)).PHP_EOL;
