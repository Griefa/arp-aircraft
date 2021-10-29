fx_version 'cerulean'
game 'gta5'

description 'An aircraft dealership for heists and Cayo Perico'
version '1.0.0' 

client_scripts {
    'config.lua',
    'cl_garage.lua'
}

server_script 'sv_garage.lua'

ui_page 'ui/index.html'

files {
    'ui/*'
}