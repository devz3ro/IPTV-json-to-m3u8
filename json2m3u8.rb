#!/usr/local/Cellar/ruby/3.0.2/bin/ruby

require 'net/http'
require 'json'

puts "\nEnter your IPTV domain and port number (Example: mystream.site:31337)"
stream_domain = gets.strip

puts "\nEnter your IPTV username:"
stream_username = gets.strip

puts "\nEnter your IPTV password:"
stream_password = gets.strip

stream_url = "http://#{stream_domain}/player_api.php?username=#{stream_username}&password=#{stream_password}&action=get_live_streams"
stream_data = URI(stream_url)
stream_response = Net::HTTP.get(stream_data)
stream_data = JSON.parse(stream_response)

category_url = "http://#{stream_domain}/player_api.php?username=#{stream_username}&password=#{stream_password}&action=get_live_categories"
category_data = URI(category_url)
category_response = Net::HTTP.get(category_data)
category_data = JSON.parse(category_response)

category_data.sort_by! { |name| 
	name["category_name"]
}

puts ""

category_data.each { |category_print|
	puts category_print["category_name"] + " = " + category_print["category_id"]
}

puts "\nEnter your desired category number(s) separated by spaces: \n"

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
                        unless epg_chan.empty?
				m3u8_file.print "tvg-id=\"" + epg_chan + "\" "
			else
				m3u8_file.print "tvg-id=\"null\"" + " "
			end
			m3u8_file.print "tvg-name=\"" + channel["name"] + "\" "
			m3u8_file.print "tvg-logo=\"" + channel["stream_icon"] + "\" "
			m3u8_file.print "group-title=\"#{group_title}\"," + channel["name"] + "\n"
                        m3u8_file.print "http://#{stream_domain}/#{stream_username}/#{stream_password}/" + channel["stream_id"].to_s + "\n"
			channel_num += 1
		end
	end
end
puts "\nlive.m3u8 created."
m3u8_file.close
