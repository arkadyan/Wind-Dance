module WeatherDataImporter
	RELATIVE_PRESSURE = 0
	INDOOR_TEMPERATURE = 1
	INDOOR_HUMIDITY = 2
	OUTDOOR_TEMPERATURE = 3
	OUTDOOR_HUMIDITY = 4
	DEWPOINT = 5
	WINDCHILL = 6
	WIND_SPEED = 7
	WIND_DIRECTION = 8
	RAIN_TOTAL = 9
	TIME = 10
	DATE = 11
	
	def pull_times_for_date(date)
		input_file = "data/spws-data-flux-809-data_only.csv"
		
		times = Array.new
		File.readlines(input_file).map do |line|
			values = line.chomp.split(',').map
			if values[DATE] == date
				times << values[TIME]
			end
		end
		times
	end
	
	def pull_data_for_date_hour(date, hour)
		input_file = "data/spws-data-flux-809-data_only.csv"
		
		hour_readings = Array.new
		File.readlines(input_file).map do |line|
			readings = line.chomp.split(',').map
			current_hour = readings[TIME].split(':')[0]
			if readings[DATE] == date && current_hour == hour
				hour_readings << {:time => readings[TIME], 
					:wind_speed => readings[WIND_SPEED], :wind_direction => readings[WIND_DIRECTION]}
			end
		end
		get_first_reading(hour_readings)
	end
	
	
	private

	def get_first_reading(readings)
		readings.first
	end
	
	def get_random_reading()
		
	end
	
end
