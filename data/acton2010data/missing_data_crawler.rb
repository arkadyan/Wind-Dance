#!/usr/bin/env ruby

require 'date'
require 'rubygems'
require 'rest_client'



def missing_an_hour(csv, date)
	missing_an_hour = false
	(0..23).each do |hour|
		if !csv.match /#{date} 0?#{hour}:/
			missing_an_hour = true
		end
	end
	missing_an_hour
end



IO.foreach('missing_dates.txt') do |line|
	date, output_file_name = line.chomp.split(',')
	year, month, day = date.split('-')
	year = year.to_i
	output_file = "individual_days/#{output_file_name}"
	
	found_complete_data = false
	while !found_complete_data
		year -= 1
		url = "http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KMAACTON4&month=#{month}&day=#{day}&year=#{year}&format=1"
		puts url
		csv = RestClient.get url
		
		if csv.length <= 193
			puts "No data for #{year}-#{month}-#{day}, #{output_file}"
		elsif csv.include? '-999'
			puts "Bad data (-999) found for #{year}-#{month}-#{day}, #{output_file}"
		elsif missing_an_hour(csv, "#{year}-#{month}-#{day}")
			puts "Missing at least one hour for #{year}-#{month}-#{day}, #{output_file}"
		else
			
			found_complete_data = true
			puts "Looks good! #{year}-#{month}-#{day}, #{output_file}"
			csv.gsub!(/<br>\n/, '').gsub!(/^\n/, '').gsub!(/\n<!-- .+? -->\n$/, '').gsub!(/Time,TemperatureF,DewpointF,PressureIn,WindDirection,WindDirectionDegrees,WindSpeedMPH,WindSpeedGustMPH,Humidity,HourlyPrecipIn,Conditions,Clouds,dailyrainin,SoftwareType/, '')
			File.open(output_file, 'w') {|f| f.write(csv) }
			
		end
		
		sleep rand(60)  # seconds
		
	end
end
