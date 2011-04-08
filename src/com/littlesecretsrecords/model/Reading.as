package com.littlesecretsrecords.model
{
	import mx.messaging.channels.StreamingAMFChannel;
	
	public class Reading
	{
		
		private var _date:String;
		private var _time:String;
		private var _windSpeed:Number;
		private var _windDirection:String;
		
		
		public function Reading(initialDate:String, initialTime:String, initialWindSpeed:Number, initialWindDirection:String)
		{
			date = initialDate;
			time = initialTime;
			windSpeed = initialWindSpeed;
			windDirection = initialWindDirection;
		}
		
		
		public function get date():String {
			return _date;
		}
		public function set date(newDate:String):void {
			_date = newDate;
		}
		
		public function get time():String {
			return _time;
		}
		public function set time(newTime:String):void {
			_time = newTime;
		}
		
		public function get windSpeed():Number {
			return _windSpeed;
		}
		public function set windSpeed(newWindSpeed:Number):void {
			_windSpeed = newWindSpeed;
		}
		
		public function get windDirection():String {
			return _windDirection;
		}
		public function set windDirection(newWindDirection:String):void {
			_windDirection = newWindDirection;
		}

	}
}