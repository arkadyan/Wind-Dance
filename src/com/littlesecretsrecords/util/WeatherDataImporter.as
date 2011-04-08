package com.littlesecretsrecords.util
{
	import com.littlesecretsrecords.model.Reading;
	
	
	public class WeatherDataImporter
	{
		
		// Input file columns
		private static const DATE:int = 0
		private static const TIME:int = 1
		private static const TEMPERATURE:int = 2
		private static const DEWPOINT:int = 3
		private static const PRESSURE:int = 4
		private static const WIND_DIRECTION:int = 5
		private static const WIND_DIRECTION_DEGREES:int = 6
		private static const WIND_SPEED:int = 7
		private static const WIND_SPEED_GUST:int = 8
		private static const HUMIDITY:int = 9
		private static const HOURLY_PRECIP:int = 10
		private static const CONDITIONS:int = 11
		private static const CLOUDS:int = 12
		private static const DAILY_RAIN:int = 13
		private static const SOFTWARE_TYPE:int = 14
		
		
		public static function pullDataForDateHour(inputFile:String, date:String, hour:int):Reading {
			var hourReadings:Array = new Array();
			
			for each (var line:String in inputFile.split('\n')) {
				var readings:Array = line.split(',');
				var currentHour:String = readings[TIME].split(':')[0];
				if (readings[DATE] == date && (currentHour==hour.toString() || currentHour=='0'+hour.toString())) {
					hourReadings = hourReadings.concat(new Reading(readings[DATE], readings[TIME], readings[WIND_SPEED], readings[WIND_DIRECTION]));
				}
			}
			
			//return getFirstReading(hourReadings);
			//return getRandomReading(hourReadings);
			return getStrongestReading(hourReadings);
		}
		
		
		private static function getFirstReading(readings:Array):Reading {
			return readings[0];
		}
		
		private static function getRandomReading(readings:Array):Reading {
			return readings[Math.floor(Math.random()*readings.length)];
		}
		
		private static function getStrongestReading(readings:Array):Reading {
			var strongestReading:Reading = readings[0];
			
			for each (var reading:Reading in readings) {
				if (reading.windSpeed > strongestReading.windSpeed) {
					strongestReading = reading;
				}
			}
			
			return strongestReading;
		}

	}
}