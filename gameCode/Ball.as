package gameCode 
{
	import flash.display.Sprite;
	
	public class Ball extends Sprite 
	{
		public var velocity:Vect;
		
		public var velocityNormal:Vect;
		public var velocityTangent:Vect;
		
		public var mass:Number = 50;
		public var radius:Number;
		public var gravity:Number = 60;
		
		public function Ball(posX:Number, posY:Number, r:Number, color:uint = 0X000000) 
		{
			this.x = posX;
			this.y = posY;
			radius = r;
			velocity = new Vect(0, 0);
			
			draw(color);
		}
		
		public function draw(color:uint):void 
		{
			graphics.beginFill(color);
			graphics.drawCircle(0,0, radius);
			graphics.endFill();
		}
			
		public function update(dt:Number)
		{
			if(this.x < 0)
			{
				velocity.x *= -1;
			}
			if(this.y < 0)
			{
				velocity.y *= -1
			}
			velocity.x *= .9;
			velocity.y += gravity;
			velocity.y *= .9;
			//trace("Vx - " + Math.round(velocity.x * dt) + " | Vy - " + Math.round(velocity.y * dt));

			this.x += velocity.x * dt;
			this.y += velocity.y * dt;
		}
	}
}