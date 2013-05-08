package gameCode 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	public class Flipper extends Sprite 
	{
		private var gravity:Number;
		private var accelleration:Number;
		public var velocity:Number = 0;
		public var isMoving:Boolean = false;
		public var angleMax:Number;
		public var nuetral:Number;
		public var angle:Number;
		
		public var start:Vect;
		public var end:Vect;
		public var wallLength:Number;
		public var unitNormal:Vect;
		public var unitTangent:Vect;
		public var thickness:Number;
		public var score:Number;
		public var bounce:Number;
		public var mass:Number = 100000;
		public var color:uint;
		
		public var endToBall:Number;
		public var startToBall:Number;
		public var deltaDist:Number;
		private var collisionNormal:Vect;
		private var edge:Boolean = false;
		private var hitLast:Boolean;
		
		private var temp:Number = 0;
		
		public function Flipper(thickness:Number, pointFrom:Vect, pointTo:Vect, accelleration:Number, gravity:Number, direction:int, angleMax:Number = Math.PI / 4, bounce:Number = .85, color:uint = 0x000000) 
		{
			this.thickness = thickness;
			this.bounce = bounce;
			this.color = color;
			this.angleMax = angleMax;
			this.accelleration = accelleration * (direction * -1);
			this.gravity = gravity * direction;
			
			if (direction > 0)
			{
				nuetral = 0;
			}
			else
			{
				nuetral = Math.PI;
			}
			
			start = pointFrom;
			end = pointTo;
			/*
			this.x = pointFrom.x;
			this.y = pointFrom.y;
			*/
			angle = Math.atan2(end.y - start.y, end.x - start.x);
			trace(angle);
			
			drawWall();
			drawCircle();
		}
		
		public function drawCircle()
		{
			graphics.beginFill(color);
			graphics.drawCircle(start.x, start.y, thickness);
			graphics.endFill();
		}
		
		protected function drawWall()
		{
			graphics.clear();
			graphics.lineStyle(thickness, color);
			graphics.moveTo(start.x, start.y);
			graphics.lineTo(end.x, end.y);
		} 
		
		public function init()
		{
			var line:Vect;
			if (accelleration < 0)
			{
				line = new Vect(end.x - start.x, end.y - start.y);
			}
			else
			{
				line = new Vect(start.x - end.x, start.y - end.y);
			}
			
			wallLength = MainApp.getMagnitude(line);
			
			unitNormal = new Vect(-line.y / wallLength, line.x / wallLength);
			
			unitTangent = new Vect(-unitNormal.y, unitNormal.x);
		}
		
		public function update(isMoving:Boolean, dt:Number)
		{
			
			if (isMoving)
			{
				if (!this.isMoving)
				{
					velocity = 0;
				}
				velocity += accelleration * dt;
			}
			else
			{
				if (this.isMoving)
				{
					velocity = 0;
				}
				velocity += gravity * dt;
			}
			if (angle > nuetral + angleMax)
			{
				temp = (end.x - start.x) * Math.cos(angle - (nuetral + angleMax)) + (end.y - start.y) * Math.sin(angle - (nuetral + angleMax)) + start.x;
				end.y = -(end.x - start.x) * Math.sin(angle - (nuetral + angleMax)) + (end.y - start.y) * Math.cos(angle - (nuetral + angleMax)) + start.y;
				end.x = temp;
				angle = nuetral + angleMax;
				velocity = 0;
			}
			if (angle < nuetral - angleMax )
			{
				temp = (end.x - start.x) * Math.cos((nuetral - angleMax) - angle) - (end.y - start.y) * Math.sin((nuetral - angleMax) - angle) + start.x;
				end.y = (end.x - start.x) * Math.sin((nuetral - angleMax) - angle) + (end.y - start.y) * Math.cos((nuetral - angleMax) - angle) + start.y;
				end.x = temp;
				angle = nuetral + angleMax;
				velocity = 0;
			}
			if (angle + velocity * dt > nuetral + angleMax)
			{
				temp = (end.x - start.x) * Math.cos((nuetral + angleMax) - angle) - (end.y - start.y) * Math.sin((nuetral + angleMax) - angle) + start.x;
				end.y = (end.x - start.x) * Math.sin((nuetral + angleMax) - angle) + (end.y - start.y) * Math.cos((nuetral + angleMax) - angle) + start.y;
				end.x = temp;
				angle = nuetral + angleMax;
				velocity = 0;
			}
			if (angle + velocity * dt < nuetral - angleMax)
			{
				temp = (end.x - start.x) * Math.cos(angle - (nuetral - angleMax)) + (end.y - start.y) * Math.sin(angle - (nuetral - angleMax)) + start.x;
				end.y = -(end.x - start.x) * Math.sin(angle - (nuetral - angleMax)) + (end.y - start.y) * Math.cos(angle - (nuetral - angleMax)) + start.y;
				end.x = temp;
				angle = nuetral - angleMax;
				velocity = 0;
			}
			if (velocity > 0)
			{
				temp = (end.x - start.x) * Math.cos(Math.abs(velocity * dt)) - (end.y - start.y) * Math.sin(Math.abs(velocity * dt)) + start.x;
				end.y = (end.x - start.x) * Math.sin(Math.abs(velocity * dt)) + (end.y - start.y) * Math.cos(Math.abs(velocity * dt)) + start.y;
				end.x = temp;
				angle += velocity * dt;
			}
			if (velocity < 0)
			{
				temp = (end.x - start.x) * Math.cos(Math.abs(velocity * dt)) + (end.y - start.y) * Math.sin(Math.abs(velocity * dt)) + start.x;
				end.y = - (end.x - start.x) * Math.sin(Math.abs(velocity * dt)) + (end.y - start.y) * Math.cos(Math.abs(velocity * dt)) + start.y;
				end.x = temp;
				angle += velocity * dt;
			}
			
			init();
			drawWall()
			drawCircle();	
			this.isMoving = isMoving;		
		}
		
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
				if (isMoving && velocity != 0)
				{
					
					velocityPrime = new Vect(-ball.velocityNormal.x * Math.abs(velocity) + ball.velocityTangent.x,
											-ball.velocityNormal.y * Math.abs(velocity) + ball.velocityTangent.y);
				}
				else
				{
					velocityPrime = new Vect(-ball.velocityNormal.x + ball.velocityTangent.x,
											-ball.velocityNormal.y + ball.velocityTangent.y);
				}
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