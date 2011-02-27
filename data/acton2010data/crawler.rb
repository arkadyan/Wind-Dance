#!/usr/bin/env ruby

require 'date'
require 'rubygems'
require 'rest_client'


i = 0
year = 2010
(1..12).each do |month|
	days_in_month = Date.civil(year, month, -1).day
	(1..days_in_month).each do |day|
		i += 1
		
		if i > 217

			
		url = "http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KMAACTON4&month=#{month}&day=#{day}&year=#{year}&format=1"
		output_file = "individual_days/#{i}.csv"
		puts url
		csv = RestClient.get url
		if csv.length > 193
			# Remove '<br>\n', the leading \n, the trailing comment, and the first line of column headers
			csv.gsub!(/<br>\n/, '').gsub!(/^\n/, '').gsub!(/\n<!-- .+? -->\n$/, '').gsub!(/Time,TemperatureF,DewpointF,PressureIn,WindDirection,WindDirectionDegrees,WindSpeedMPH,WindSpeedGustMPH,Humidity,HourlyPrecipIn,Conditions,Clouds,dailyrainin,SoftwareType/, '')
			File.open(output_file, 'w') {|f| f.write(csv) }
		else
			puts "No data for #{year}-#{month}-#{day}, #{output_file}"
		end
			
		sleep rand(60)  # seconds
		
		
		end
		
	end
end
