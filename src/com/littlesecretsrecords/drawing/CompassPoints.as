package com.littlesecretsrecords.drawing
{
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;

	public class CompassPoints extends Canvas
	{
		
		private static const COMPASS_STROKE_COLOR:int = 0x000000;
		private static const COMPASS_STROKE_ALPHA:int = 1;
		private static const CARDINAL_LENGTH:int = 10;
		private static const CARDINAL_WEIGHT:int = 4;
		private static const INTERMEDIATE_LENGTH:int = 7;
		private static const INTERMEDIATE_WEIGHT:int = 2;
		private static const MINOR_LENGTH:int = 4;
		private static const MINOR_WEIGHT:int = 1;
		
		
		private var center:int;
		
		
		public function CompassPoints(initialWidth:int, initialHeight:int)
		{
			super();
			
			width = initialWidth;
			height = initialHeight;
			
			center = width / 2;
			
			addEventListener(FlexEvent.CREATION_COMPLETE, draw);
		}
		
		
		private function draw(event:FlexEvent=null):void {
			graphics.clear();
			
			// Cardinal directions
			graphics.lineStyle(CARDINAL_WEIGHT, COMPASS_STROKE_COLOR, COMPASS_STROKE_ALPHA);
			drawOppositeCompassPoints(CARDINAL_LENGTH, Math.PI/2);
			
			// Intermediate directions
			graphics.lineStyle(INTERMEDIATE_WEIGHT, COMPASS_STROKE_COLOR, COMPASS_STROKE_ALPHA);
			drawOppositeCompassPoints(INTERMEDIATE_LENGTH, Math.PI/4);
			
			// Minor directions
			graphics.lineStyle(MINOR_WEIGHT, COMPASS_STROKE_COLOR, COMPASS_STROKE_ALPHA);
			drawOppositeCompassPoints(MINOR_LENGTH, Math.PI/8);
			drawOppositeCompassPoints(MINOR_LENGTH, Math.PI/8 + Math.PI/4);
		}
		
		private function drawOppositeCompassPoints(length:int, angle:Number):void {
			var topOrigin:Point = Point.polar(center, angle);
			var topDest:Point = Point.polar(center-length, angle);
			topOrigin.offset(center, center);
			topDest.offset(center, center);
			graphics.moveTo(topOrigin.x, topOrigin.y);
			graphics.lineTo(topDest.x, topDest.y);
			
			var bottomOrigin:Point = Point.polar(-center, angle);
			var bottomDest:Point = Point.polar(-center+length, angle);
			bottomOrigin.offset(center, center);
			bottomDest.offset(center, center);
			graphics.moveTo(bottomOrigin.x, bottomOrigin.y);
			graphics.lineTo(bottomDest.x, bottomDest.y);
			
			var leftOrigin:Point = Point.polar(center, Math.PI/2+angle);
			var leftDest:Point = Point.polar(center-length, Math.PI/2+angle);
			leftOrigin.offset(center, center);
			leftDest.offset(center, center);
			graphics.moveTo(leftOrigin.x, leftOrigin.y);
			graphics.lineTo(leftDest.x, leftDest.y);
			
			var rightOrigin:Point = Point.polar(-center, Math.PI/2+angle);
			var rightDest:Point = Point.polar(-center+length, Math.PI/2+angle);
			rightOrigin.offset(center, center);
			rightDest.offset(center, center);
			graphics.moveTo(rightOrigin.x, rightOrigin.y);
			graphics.lineTo(rightDest.x, rightDest.y);
		}	
		
	}
}