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
	
	
	def get_all_dates
	end
	
	def pull_times_for_date(input_file, date)
		times = Array.new
		read_data(input_file).map do |line|
			values = line.chomp.split(',').map
			if values[DATE] == date
				times << values[TIME]
			end
		end
		times
	end
	
	def pull_data_for_date_hour(input_file, date, hour)
		hour_readings = Array.new
		read_data(input_file).map do |line|
			readings = line.chomp.split(',').map
			current_hour = readings[TIME].split(':')[0]
			if readings[DATE] == date && current_hour == hour
				hour_readings << {:time => readings[TIME], 
					:wind_speed => readings[WIND_SPEED], :wind_direction => readings[WIND_DIRECTION]}
			end
		end
		# get_first_reading(hour_readings)
		# get_random_reading(hour_readings)
		get_strongest_reading(hour_readings)
	end
	
	
	private
	
	def read_data(input_file)
		File.readlines(input_file)
	end

	def get_first_reading(readings)
		readings.first
	end
	
	def get_random_reading(readings)
		readings[rand(readings.length)]
	end
	
	def get_strongest_reading(readings)
		strongest_reading = readings.first
		readings.each do |reading|
			strongest_reading = reading if reading[:wind_speed] > strongest_reading[:wind_speed]
		end
		strongest_reading
	end
	
end
