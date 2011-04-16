package com.littlesecretsrecords.drawing
{
	import flash.geom.Point;
	
	import mx.containers.Canvas;

	public class WindBarb extends Canvas
	{
		
		private static const BARB_STROKE_COLOR:uint = 0x000000;
		private static const BARB_STROKE_WEIGHT:int = 2;
		
		private static const MAIN_LINE_LENGTH:int = 80;
		private static const DOT_WIDTH:int = 3;
		private static const CIRCLE_WIDTH:int = 20;
		
		// Arrow head height and (center-to-edge) width
		private static const ARROW_LINE_LENGTH:int = 80;
		private static const ARROW_STROKE_COLOR:int = 50;
		private static const ARROW_STROKE_WEIGHT:int = 1;
		private static const ARROW_DOT_WIDTH:int = 1;
		private static const ARROW_DOT_OFFSET:int = 8;
		private static const ARROW_DOT_SEPARATION:int = 4;
		
		
		private var _pos:Point;
		private var _speed:Number;
		private var _direction:String;
		private var _previousBarb:WindBarb;
		private var _lastCalmBarb:Boolean;
		
		
		public function WindBarb(initialPos:Point, initalSpeed:Number, initialDirection:String, initialPreviousBarb:WindBarb)
		{
			super();
			
			pos = initialPos;
			speed = initalSpeed;
			direction = initialDirection;
			previousBarb = initialPreviousBarb;
			
			lastCalmBarb = false;
		}
		
		
		public function get pos():Point {
			return _pos;
		}
		public function set pos(newPos:Point):void {
			_pos = newPos;
		}
		
		public function get speed():Number {
			return _speed;
		}
		public function set speed(newSpeed:Number):void {
			_speed = newSpeed;
		}
		
		public function get direction():String {
			return _direction;
		}
		public function set direction(newDirection:String):void {
			_direction = newDirection;
		}
		
		public function get previousBarb():WindBarb {
			return _previousBarb;
		}
		public function set previousBarb(newPreviousBarb:WindBarb):void {
			_previousBarb = newPreviousBarb;
		}
		
		public function get lastCalmBarb():Boolean {
			return _lastCalmBarb;
		}
		public function set lastCalmBarb(newLastCalmBarb:Boolean):void {
			_lastCalmBarb = newLastCalmBarb;
		}
		
		
		public function get directionInRadians():Number {
			switch (direction) {
				case 'E':
					return 0;
					break;
				case 'ENE':
					return -Math.PI/8;
					break;
				case 'NE':
					return -Math.PI/4;
					break;
				case 'NNE':
					return -Math.PI*3/8;
					break;
				case 'N':
					return -Math.PI/2;
					break;
				case 'NNW':
					return -Math.PI*5/8;
					break;
				case 'NW':
					return -Math.PI*3/4;
					break;
				case 'WNW':
					return -Math.PI*7/8;
					break;
				case 'W':
					return -Math.PI;
					break;
				case 'WSW':
					return -Math.PI*9/8;
					break;
				case 'SW':
					return -Math.PI*5/4;
					break;
				case 'SSW':
					return -Math.PI*11/8;
					break;
				case 'S':
					return -Math.PI*3/2;
					break;
				case 'SSE':
					return -Math.PI*13/8;
					break;
				case 'SE':
					return -Math.PI*7/4;
					break;
				case 'ESE':
					return -Math.PI*15/8;
					break;
				default:
					return 0;
					break;
			}
		}
		
	}
}