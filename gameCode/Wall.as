package gameCode 
{
	import flash.display.Sprite;
	
	/**
	 * WALL
	 * 
	 * Procedurally generated line that the ball bounces off of
	 **/
	public class Wall extends Sprite 
	{
		public var start:Vect; // The starting point of the line
		public var end:Vect; // the ending point of the line
		public var wallLength:Number; // the length of the wall
		public var unitNormal:Vect; // The normal vector to the line
		public var unitTangent:Vect; // The tangent vector to the line
		public var thickness:Number; // the thickness of the line
		public var score:Number; // The score from hitting the wall
		public var bounce:Number; // The bounce strength of the wall
		public var mass:Number = 100000; // The mass of the wall
		
		public var endToBall:Number; // The distance from end to ball
		public var startToBall:Number; // the distance from start to ball
		public var deltaDist:Number; // The differenct of the ball from the line
		private var collisionNormal:Vect; // The normal vector of the collision
		private var edge:Boolean = false; // if the ball hits the edge
		private var hitLast:Boolean; // if the ball was hit last frame
		
		public function Wall(thickness:Number, pointFrom:Vect, pointTo:Vect, bounce = .85, color:uint = 0x000000)
		{
			this.thickness = thickness;
			this.bounce = bounce;
			
			start = pointFrom;
			end = pointTo;
						
			drawWall(color);
		}
				
		// procedurally draws the wall
		protected function drawWall(color:uint)
		{
			graphics.lineStyle(thickness, color);
			graphics.moveTo(start.x, start.y);
			graphics.lineTo(end.x, end.y);
		}
		
		// initializes values of the line
		public function init()
		{
			var line:Vect = new Vect(end.x - start.x, end.y - start.y);
			
			wallLength = MainApp.getMagnitude(line);
			
			unitNormal = new Vect(-line.y / wallLength, line.x / wallLength);
			
			unitTangent = new Vect(-unitNormal.y, unitNormal.x);

		}
		
		// Checks the collision of the ball on the line
		public function collide(ball:Ball, dt:Number):Boolean
		{			
			endToBall = MainApp.getMagnitude(new Vect(end.x - ball.x, end.y - ball.y)); //from the end of line to ball
			
			startToBall = MainApp.getMagnitude(new Vect(start.x - ball.x, start.y - ball.y)); //from the start of the line to the ball
			
			ball.velocityNormal = MainApp.projectVector(ball.velocity, unitNormal); //the ball's velocity in the relative normal position
			
			deltaDist = Math.abs(MainApp.dotProduct(unitNormal, new Vect(end.x - ball.x, end.y - ball.y))); //the distance from the ball to the line
			var toHit = (deltaDist + ball.radius) / MainApp.getMagnitude(ball.velocityNormal); //tunneling check. is the ball's current velocity in the normal direction
																								//fast enough to pass through the line? Min distance is
																								// ballRadius + thickness
																								
			//trace(toHit);
			//trace("dt:" + dt);
			
			if (toHit < dt && toHit > 0) //if the velocity is too fast, toHit will turn out to be a fraction,
			{								//which is also the percent distance the ball currently is away from the line
				if(!hitLast)
				{
					ball.velocityTangent = MainApp.projectVector(ball.velocity, unitTangent);
			
					ball.x += ball.velocityNormal.x * toHit;
					ball.y += ball.velocityNormal.y * toHit;
					ball.x += ball.velocityTangent.x * toHit;
					ball.y += ball.velocityTangent.y * toHit;
				
					deltaDist = Math.abs(MainApp.dotProduct(unitNormal, new Vect(end.x - ball.x, end.y - ball.y)));
					hitLast = true;
					return true;
				}
				else
				{
					hitLast = false;
				}
			}
			
			if(deltaDist == 15)
			{
				return true;
			}
			else if (deltaDist < ball.radius + (thickness / 2) && //begins actual checking for where the ball is
				endToBall < wallLength + ball.radius &&
				startToBall < wallLength + ball.radius)
			{
				if (!hitLast)
				{
					if (endToBall > wallLength) //if the ball is hitting the edge of the wall, make a new collisional normal from wall edge to ball center
					{
						collisionNormal = MainApp.unitize(new Vect(start.x - ball.x, start.y - ball.y));
						edge = true;
						hitLast = true;
						return true;
					}
					else if (startToBall > wallLength)
					{
						collisionNormal = MainApp.unitize(new Vect (end.x - ball.x, end.y - ball.y));
						edge = true;
						hitLast = true;
						return true;
					}
					else //if its hitting the center of the wall, then use the wall vector's regular normal
					{
						edge = false;
						hitLast = true;
						return true;
					}
				}
			}
			else
			{
				hitLast = false;
			}

			return false;
		}
		
		// reflects the ball off the line
		public function reflect(ball:Ball):Vect
		{
			
			if(deltaDist == 15)
			{
				return new Vect(ball.velocityTangent.x * 5,ball.velocityTangent.y * 5);
			}
			
			if (edge)
			{
				ball.velocityNormal = MainApp.projectVector(ball.velocity, collisionNormal); //ball could be bouncing off the edge. calculate new normal...again. urgh.
				
				ball.velocityTangent = MainApp.projectVector(ball.velocity, new Vect(-collisionNormal.y, collisionNormal.x));
			}
			else
			{
				ball.velocityTangent = MainApp.projectVector(ball.velocity, unitTangent);
			}
			
			var newVelocityNormal = (MainApp.getMagnitude(ball.velocityNormal) * (ball.mass - this.mass)) /
														(ball.mass + this.mass);
														
														
			var vnPrime = MainApp.multiplyVector(unitNormal, newVelocityNormal);
			
			var velocityPrime:Vect;
			
			if (vnPrime.x < 0 && ball.velocityNormal.x < 0 ||
				vnPrime.x > 0 && ball.velocityNormal.x > 0)
			{
				velocityPrime = new Vect(-ball.velocityNormal.x + ball.velocityTangent.x,
										 -ball.velocityNormal.y + ball.velocityTangent.y);
			}
			else
			{
				velocityPrime = new Vect(vnPrime.x + ball.velocityTangent.x,
										 vnPrime.y + ball.velocityTangent.y);
			}
			return velocityPrime;
		}
	}
}