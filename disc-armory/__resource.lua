resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Disc Armory'

version '1.1.0'

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'config.weapons.lua',
    'client/main.lua',
    'locales/cs.lua',
    'locales/en.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/main.lua',
}
