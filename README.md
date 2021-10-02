# IPTV-json-to-m3u8

This program was written using Ruby v3 and tested both on Fedora 34 & macOS Catalina & Big Sur.

Two gems are required to run this program:

gem install json

gem install down

For now, the following ***bold*** values need to be changed:

http://***mystream.site:31337***/player_api.php?username=***USERNAMEHERE***&password=***PASSWORDHERE***&action=get_live_streams
http://***mystream.site:31337***/player_api.php?username=***USERNAMEHERE***&password=***PASSWORDHERE***&action=get_live_categories

http://***mystream.site:31337***/***USERNAMEHERE***/***PASSWORDHERE***/
