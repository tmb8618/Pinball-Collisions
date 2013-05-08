package gameCode 
{
	import flash.display.Sprite;
	
	public class Bumper extends Sprite
	{
		
		public var radius:Number;
		public var color:uint;
		public var score:int;
		
		public function Bumper(posX:Number, posY:Number, r:Number, color:uint = 0x000000, points:int = 500) 
		{
			this.x = posX;
			this.y = posY;
			radius = r;
			score = points;
			this.color = color;
			
			draw();
		}
		
		public function draw():void 
		{
			graphics.lineStyle(2);
			graphics.beginFill(color);
			
			graphics.endFill();
		}
		
	}

}