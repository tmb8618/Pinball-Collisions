package gameCode
{
	import flash.display.Sprite;

	/*
		SPRING CLASS
			Takes two webVertexes and draws a line in between them.
			The line is then made to act like a spring, by giving it an inital lenght (calculated by the distance between the
			two intial points) and a spring constant. In the update, the spring changes the points' velocites, and then
			redraws the line to reconnect the points.
	*/

	/* ADD THICKNESS FOR SPRING*/

	public class Spring extends Sprite
	{
		
		private var p1:Vector;
		private var p2:Vector;
		
		private var vx:Number;
		private var vy:Number;
		
		private var friction:Number = .95;
		
		private var k:Number;
		private var intialLength:Number;
		
		
		public function Spring(start:Vector, end:Vector, springConstant:Number)
		{	
			p1 = start;
			p2 = end;
			k = springConstant;
			intialLength = Math.sqrt(Math.pow(p2.x - p1.x, 2) +
									 Math.pow(p2.y - p1.y, 2));
			graphics.lineStyle(2);
			
			drawSpring();
		}
		
		/*
			Draws the springs between the two spring points. These two are updated by the points at the end and the update method.
			
		*/
		
		private function drawSpring():void
		{
			graphics.moveTo(p1.x, p1.y);
			graphics.lineTo(p2.x, p2.y);
		}
		
		/*
			Find the length of the spring. Pythagoras strikes again.
		*/
		
		private function getLength():Number
		{
			var dX = p2.x - p1.x;
			var dY = p2.y - p1.y;
			var len:Number = (Math.sqrt(
					Math.pow(dX, 2) +
					Math.pow(dY, 2)));
			
			return len;
		}
		
		/*
			Spring update code. Changes the vetextes vx and vy based on where the spring is pulling toward.
			Calculates both ends of the spring.			
		*/
		
		public function update():void
		{
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			var angle:Number = Math.atan2(dy, dx);
			
			var goingToX:Number = Math.round(dx - (Math.cos(angle) * intialLength));
			var goingToY:Number = Math.round(dy - (Math.sin(angle) * intialLength));
			
			dx = p1.x - p2.x;
			dy = p1.y - p2.y;
			angle = Math.atan2(dy, dx);
			
			goingToX = Math.round(dx - (Math.cos(angle) * intialLength));
			goingToY = Math.round(dy - (Math.sin(angle) * intialLength));
			
			graphics.clear();
			
			drawSpring();
		}
	}
}