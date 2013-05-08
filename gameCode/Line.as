package gameCode 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * LINE
	 * 
	 * procedurally draws a line that can redrawn between
	 * two given points
	 **/
	public class Line extends Sprite 
	{
		public var point1:Point;	// The starting point 
		public var point2:Point;	// The ending point
		public var thickness:Number;	// How thick the line is drawn
		public var color:uint;	// The color of the line
		
		public function Line(point1:Point, point2:Point, thickness:Number = 1, color:uint = 0x000000) 
		{
			this.thickness = thickness;
			this.color = color;
			update(point1, point2);
		}
		
		// draws a line based on the points provided
		public function update(point1:Point, point2:Point):void
		{
			graphics.clear();
			this.point1 = point1;
			this.point2 = point2;
			graphics.lineStyle(thickness, color);
			graphics.moveTo(point1.x, point1.y);
			graphics.lineTo(point2.x, point2.y);
		}
		
	}

}