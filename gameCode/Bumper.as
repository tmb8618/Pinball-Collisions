package gameCode 
{
	import flash.display.Sprite;
	
	/**
	 * BUMPER
	 * 
	 * Color and size changing circle
	 * collides with the ball and propells it away.
	 **/
	public class Bumper extends Sprite
	{
		
		public var radius:Number; // The radius of the circle
		
		public var POWER:Number = 1.5; // The power of the Bounce
		
		public var color:uint; // The color of the circle
		public var score:int; // The score for hitting the bumper
		private var mass:int = 100000; // The mass of the bumper
		public var hitLast:Boolean = false; // Prevents repeated collision
		public var colorLoc = 0; // I have no idea
		
		public var deltaVect:Vect; // The delta vector of the collision
		public var unitNormal:Vect; // The normal vector between the ball and the bu,per
		
		public var isSmall:Boolean = false; // If the bumper is smaller than its starting size
		public var adjust:Number; // the change in size of the bumper
		public var dColor:uint; // the color the bumper will change to
		
		
		public function Bumper(posX:Number, posY:Number, r:Number, bounce:Number, color:uint = 0x000000, points:int = 500, adjust:Number = 5, dColor:uint = 0x0000f0) 
		{
			this.x = posX;
			this.y = posY;
			radius = r;
			score = points;
			this.color = color;
			POWER = bounce;
			this.adjust = adjust;
			this.dColor = dColor;
			
			draw();
		}
		
		// draws the bumper
		public function draw():void 
		{			
			graphics.lineStyle(1, 0x000000);
			graphics.beginFill(color);
			graphics.drawCircle(0,0, radius);
			graphics.endFill();
		}
		
		// changs the size and color of the bumber then it redraws it
		public function update(r:Number, newColor:uint)
		{
			this.radius += r;
			this.color = newColor;
			
			graphics.clear();			
			draw();
		}
		
		// calculates if the ball collides with this bumper
		public function collide(ball:Ball):Boolean
		{
			
			deltaVect = new Vect(ball.x - this.x, ball.y - this.y);
			
			unitNormal = MainApp.unitize(deltaVect);
			
			ball.velocityNormal = MainApp.projectVector(ball.velocity, unitNormal); //velocity of the ball in the normal direction of the bumper
			
			/*var toHit = (MainApp).getMagnitude(deltaVect) + (radius * 2 + ball.radius * 2)) /
						 MainApp.getMagnitude(ball.velocityNormal);
			
			if (toHit > 0 && toHit < 1)
			{
				var unitTangent:Vect = new Vect(-unitNormal.y, unitNormal.x); //vector tangent to the normal
				
				ball.velocityTangent =MainApp.projectVector(ball.velocity, unitTangent);
				
				ball.x += ball.velocityNormal.x * toHit;
				ball.y += ball.velocityNormal.y * toHit;
				ball.x += ball.velocityTangent.x * toHit;
				ball.y += ball.velocityTangent.y * toHit;
			}*/
			
			if (Math.abs(deltaVect.x) < ball.radius + this.radius &&
				Math.abs(deltaVect.y) < ball.radius + this.radius)
			{
				
				if(!hitLast)
				{ 
					hitLast = true;
					return true;
				}
			}
			else
			{
				hitLast = false;
			}
			return false;
		}
		
		// calculates the bounce of the ball off the bumper
		public function bounce(ball:Ball)
		{			
			var unitTangent:Vect = new Vect(-unitNormal.y, unitNormal.x); //vector tangent to the normal
			
			ball.velocityTangent = MainApp.projectVector(ball.velocity, unitTangent); //ball's velocity in the tangent direction
						
			var newVelocityNormal = ((MainApp.getMagnitude(ball.velocityNormal) * (this.mass - ball.mass)) /
														(this.mass + ball.mass)) * POWER; //new normal velocity. 

			var vnPrime:Vect = MainApp.multiplyVector(unitNormal, newVelocityNormal); //'expand' the new velocity along the unit normal vector
			
			//var vtPrime:Vect = MainApp.multiplyVector(unitTangent, MainApp.getMagnitude(ball.velocityTangent)); //'expand' the new velocity along the unit tangent vector
			
			var velocityPrime = new Vect(vnPrime.x + ball.velocityTangent.x,
										 vnPrime.y + ball.velocityTangent.y);
										
			if (isSmall)
			{
				// resets back to original size and gives a radom shade of the color provided
				update(adjust, Math.round(Math.random() * 16) * dColor);
				isSmall = false;
			}
			else
			{
				// shrinks down and gives a radom shade of the color provided
				update(-adjust, Math.round(Math.random() * 16) * dColor);
				isSmall = true;
			}
			
			// returns the velocity of the ball after the bounce
			return velocityPrime;
		}
	}
}