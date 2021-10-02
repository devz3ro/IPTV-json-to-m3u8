#!/usr/local/Cellar/ruby/3.0.2/bin/ruby
require 'rubygems'
require 'json'

system 'wget -O streams.json "http://mystream.site:31337/player_api.php?username=USERNAMEHERE&password=PASSWORDHERE&action=get_live_streams"'
system 'wget -O categories.json "http://mystream.site:31337/player_api.php?username=USERNAMEHERE&password=PASSWORDHERE&action=get_live_categories"'

stream_file = File.read('streams.json')
stream_data = JSON.parse(stream_file)
category_file = File.read('categories.json')
category_data = JSON.parse(category_file)

category_data.sort_by! { |name| 
	name["category_name"]
}

category_data.each { |category_print|
	puts category_print["category_name"] + " = " + category_print["category_id"]
}

puts "\nPlease enter your category number(s) separated by spaces: "

input = gets.chomp
stdin = input.split(" ")
channel_num = 1
group_title = 0

m3u8_file = File.open("live.m3u8", "w:UTF-8")

m3u8_file.puts "#EXTM3U"

stdin.each do |user_input|
	category_data.each do |group|
		if group["category_id"] == "#{user_input}"
			group_title = group["category_name"]
		end
	end
	stream_data.each do |channel|
		if channel["category_id"] == "#{user_input}"
			m3u8_file.print "#EXTINF:-1 channel-id=\"#{channel_num}\" "
			epg_chan = channel["epg_channel_id"].to_s
			unless epg_chan == ""
				m3u8_file.print "tvg-id=\"" + epg_chan + "\" "
			else
				m3u8_file.print "tvg-id=\"null\"" + " "
			end
			m3u8_file.print "tvg-name=\"" + channel["name"] + "\" "
			m3u8_file.print "tvg-logo=\"" + channel["stream_icon"] + "\" "
			m3u8_file.print "group-title=\"#{group_title}\"," + channel["name"] + "\n"
			m3u8_file.print "http://mystream.site:31337/USERNAMEHERE/PASSWORDHERE/" + channel["stream_id"].to_s + "\n"
			channel_num += 1
		end
	end
end

m3u8_file.close