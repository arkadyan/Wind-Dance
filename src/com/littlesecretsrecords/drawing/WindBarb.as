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
		
		
		private var _speed:Number;
		private var _direction:String;
		private var _pos:Point;
		private var _previousBarb:WindBarb;
		private var _lastCalmBarb:Boolean;
		
		
		public function WindBarb(initalSpeed:Number, initialDirection:String, initialPreviousBarb:WindBarb)
		{
			super();
			
			//@pos = Point.new(width/2, height/2)
			
			speed = initalSpeed;
			direction = initialDirection;
			previousBarb = initialPreviousBarb;
			
			lastCalmBarb = false;
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
		
		public function get pos():Point {
			return _pos;
		}
		public function set pos(newPos:Point):void {
			_pos = newPos;
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
		
	}
}