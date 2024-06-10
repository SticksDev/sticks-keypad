fx_version "cerulean"

description "A simple keypad script for FiveM"
author "sticksdev"
version '1.0.0'
repository 'https://github.com/SticksDev/sticks-keypad'

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

ui_page 'web/build/index.html'

client_script "client/**/*"
server_script "server/**/*"

files {
	'web/build/index.html',
	'web/build/**/*',
}