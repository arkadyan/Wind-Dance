package com.littlesecretsrecords.data
{
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
		
		
		public static function pullDataForDateHour(inputFile:String, date:int, hour:int):String {
			var hourReadings:Array = new Array();
			
			
		}
		
		
		private function getFirstReading(readings) {
			
		}

	}
}