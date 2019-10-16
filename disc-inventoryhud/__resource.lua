resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

ui_page 'html/ui.html'

client_scripts {
    'client/main.lua',
    'client/actions.lua',
    'client/inventory.lua',
    'client/drop.lua',
    'client/trunk.lua',
    'client/glovebox.lua',
    'client/shop.lua',
    'client/weapons.lua',
    'client/search.lua',
    'client/stash.lua',
    'common/drop.lua',
    'config.lua',
    'utils.lua'
}

server_scripts {
    'server/main.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/actions.lua',
    'server/inventory.lua',
    'server/player.lua',
    'server/drop.lua',
    'server/trunk.lua',
    'server/glovebox.lua',
    'server/shop.lua',
    'server/weapons.lua',
    'server/search.lua',
    'server/stash.lua',
    'server/itemdata.lua',
    'common/drop.lua',
    'config.lua',
    'utils.lua'
}

files {
    'html/ui.html',
    'html/css/style.min.css',
    'html/js/inventory.js',
    'html/js/config.js',
    'html/css/jquery-ui.min.css',
    'html/css/bootstrap.min.css',
    'html/js/jquery.min.js',
    'html/js/jquery-ui.min.js',
    'html/js/bootstrap.min.js',
    'html/js/popper.min.js',

    -- IMAGES
    'html/img/bullet.png',
    'html/img/cash.png',
    'html/img/bank.png',
    'html/success.wav',
    'html/fail.wav',
    -- ICONS

    'html/img/items/*.png',
}

dependencies {
    'es_extended'
}