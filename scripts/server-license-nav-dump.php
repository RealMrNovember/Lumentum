<?php

$root = dirname(__DIR__, 2) === dirname(__DIR__) ? __DIR__ . '/..' : '/www/wwwroot/license.cicibyte.com';
if (! is_file($root . '/vendor/autoload.php')) {
    $root = '/www/wwwroot/license.cicibyte.com';
}

require $root . '/vendor/autoload.php';

$app = require $root . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$user = App\Models\User::query()->first();
if (! $user) {
    echo "NO_USER\n";
    exit(1);
}

auth()->login($user);
app()->setLocale('en');

$panel = Filament\Facades\Filament::getPanel('admin');
$nav = $panel->getNavigation();

echo 'GROUPS=' . count($nav) . PHP_EOL;
foreach ($nav as $g) {
    $label = $g->getLabel() ?? '(empty)';
    echo "LABEL=[{$label}] items=" . count($g->getItems()) . PHP_EOL;
    foreach ($g->getItems() as $item) {
        echo '  - ' . $item->getLabel() . ' => ' . $item->getUrl() . PHP_EOL;
    }
}

$request = Illuminate\Http\Request::create('/admin', 'GET');
$response = $app->handle($request);
$html = $response->getContent();

preg_match_all('/fi-sidebar-group-label[^>]*>\s*([^<]+)/', $html, $labels);
preg_match_all('/fi-sidebar-item-label[^>]*>\s*([^<]+)/', $html, $items);

echo 'HTML_LABELS=' . implode(' | ', array_map('trim', $labels[1] ?? [])) . PHP_EOL;
echo 'HTML_ITEMS=' . implode(' | ', array_map('trim', $items[1] ?? [])) . PHP_EOL;
echo 'HTML_GROUP_TAGS=' . substr_count($html, 'class="fi-sidebar-group ') . PHP_EOL;

foreach ($nav as $g) {
    $label = $g->getLabel() ?? '(empty)';
    echo 'COLLAPSIBLE[' . $label . ']=' . ($g->isCollapsible() ? 'yes' : 'no') . PHP_EOL;
}

if (preg_match('/<ul class="fi-sidebar-nav-groups[^"]*">(.*?)<\/ul>\s*\n\s*{{/s', $html, $m)) {
    echo 'NAV_HTML_LEN=' . strlen($m[1]) . PHP_EOL;
} elseif (preg_match('/fi-sidebar-nav-groups(.*?)<\/nav>/s', $html, $m)) {
    echo 'NAV_HTML_LEN=' . strlen($m[1]) . PHP_EOL;
}

preg_match_all('/<ul class="fi-sidebar-group-items[^"]*"[^>]*>/', $html, $uls);
echo 'GROUP_ITEMS_ULS=' . count($uls[0]) . PHP_EOL;
foreach ($uls[0] as $ul) {
    echo 'UL_ATTRS=' . $ul . PHP_EOL;
}
