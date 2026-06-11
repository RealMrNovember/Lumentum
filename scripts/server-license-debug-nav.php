<?php

require '/www/wwwroot/license.cicibyte.com/vendor/autoload.php';
$app = require '/www/wwwroot/license.cicibyte.com/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$panel = Filament\Facades\Filament::getPanel('admin');
echo 'collapsibleNavigationGroups='.($panel->hasCollapsibleNavigationGroups() ? 'yes' : 'no').PHP_EOL;
echo 'sidebarCollapsibleOnDesktop='.($panel->isSidebarCollapsibleOnDesktop() ? 'yes' : 'no').PHP_EOL;

foreach ($panel->getNavigation() as $group) {
    echo 'GROUP ['.$group->getLabel().'] collapsible='.($group->isCollapsible() ? 'yes' : 'no').' items='.count($group->getItems()).PHP_EOL;
}
