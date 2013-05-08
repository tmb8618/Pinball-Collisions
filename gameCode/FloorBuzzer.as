package gameCode 
{
	import flash.display.Sprite;
	
	public class FloorBuzzer extends Sprite 
	{
		
		public var radius:Number;
		public var standingColor:uint;
		public var hitColor:uint;
		public var score:int;
		public var colliding:Boolean;

		
		public function FloorBuzzer(posX:Number, posY:Number, r:Number, color1:uint = 0X000000, color2:uint = 0XFF0000, points:int = 250) 
		{
			this.x = posX;
			this.y = posY;
			radius = r;
			standingColorcolor = color1;
			hitColor = color2;
			colliding = false;
			
			graphics.lineStyle(2);
			
			draw();
		}
		
		public function draw():void 
		{
			switch (colliding)
			{
				case true:
				graphics.beginFill(hitColor);
				break;
				
				case false:
				graphics.beginFill(standingColor);
				break;
			}
			
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
		}
		
		public function collideCheck(ball:Ball)
		{
			var deltaX:int = this.x - ball.x;
			var deltaY:int = this.y - ball.y;
			
			if (!colliding &&
				ball.radius + this.radius <= deltaX &&
				ball.radius + this.radius <= deltaY)
				{
					colliding = true;
					(parent as MainApp).addPoints(score);
					return;
				}
			colliding = false;
		}
		
	}

}