package gameCode 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * PLUNGER
	 * 
	 * launches the ball off it when the handle
	 * is pulled and released
	 **/
	public class Plunger extends Sprite 
	{
		public var box:Box;	// the graphical housing of the system and where the ball rest
		public var line:Line;	// The top of the striking hammer that launches the ball
		public var spring:Line;	// The spring that pulls the handle back to neutral
		public var handle:Ball;	// The handle of the plunger holds the mass, velocity it will it the ball with
		
		public var K:Number;	// The spring constant strength
		public var isDown:Boolean = false;	// detemines if the left mouse button is down on the handle
		
		
		public function Plunger(W:Number, L:Number, radius:Number, mass:Number, K:Number, boxColor:uint = 0x0000ff,
									springColor:uint = 0x00ff00, ballColor:uint = 0xff0000,
									lineColor:uint = 0x000000, lineThick:Number = 5,
									springThick:Number = 5)
		{
			box = new Box(W, L, boxColor);
			addChild(box);
			
			line = new Line(new Point(0, 0), new Point(W, 0), lineThick, lineColor);
			addChild(line);
			
			spring = new Line(new Point(W / 2, L), new Point(W / 2, L + radius), springThick, springColor)
			addChild(spring);
			
			handle = new Ball(0,0,radius,ballColor);
			addChild(handle);
			handle.mass = mass;
			handle.x = W / 2;
			handle.y = L + radius;
			
			this.K = K;
		}
		
		// turns on the event handlers of the plunger
		public function activate():void
		{
			handle.addEventListener(MouseEvent.MOUSE_DOWN, down)
			stage.addEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		// stores that the mouse is down on the handle
		private function down(e:MouseEvent):void 
		{
			trace("pulling");
			isDown = true;
		}
		
		// stores that the mouse was released
		private function up(e:MouseEvent):void 
		{
			isDown = false;
			stage.focus = (parent as MainApp);
		}
		
		// turns off the event handlers of the plunger
		public function deactivate():void
		{
			handle.removeEventListener(MouseEvent.MOUSE_DOWN, down)
			stage.removeEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		// checks for collision with the ball
		public function collideWith(ball:Ball):Boolean
		{
			if (ball.x < this.x + box.W && ball.x > this.x)
			{
				if (ball.y + ball.radius >= this.y - 0.5)
				{
					return true;
				}
			}
			return false;
		}
		
		// updates the states of the plunger
		public function update(dt):void
		{
			if (isDown == true)
			{
				// stops movement and sets the y poition to the mouseY
				handle.velocity.y = 0;
				handle.y = mouseY;
				
				// limits how far the handle can move
				if (handle.y < box.L + handle.radius)
				{
					handle.y = box.L + handle.radius;
				}
				if (handle.y > 2 * box.L + handle.radius)
				{
					handle.y = 2 * box.L + handle.radius;
				}
			}
			else
			{
				// moves the handle with the force of a spring
				handle.velocity.y += (( -K) * (handle.y - (box.L + handle.radius))) / handle.mass * dt;
				handle.y += handle.velocity.y * dt;
				
				checkHandle();
			}
			
			// updates the position of the art
			line.update(new Point(0, handle.y - (box.L + handle.radius)), new Point(box.W, handle.y - (box.L + handle.radius)));
			spring.update(new Point(box.W / 2, box.L), new Point(handle.x, handle.y));
			
		}
		
		// checks if the hanlde has collided with the holder
		// if the handle has collided and the ball is touching
		// it transfors the momentum of the handle to the ball
		public function checkHandle():void
		{
			if (handle.y <= box.L + handle.radius)
			{
				if ((parent as MainApp).onStart == true)
				{
					trace("pushing");
					(parent as MainApp).ball.velocity.y += (handle.velocity.y * handle.mass) / (parent as MainApp).ball.mass;
				}
				handle.velocity.y = 0;
				handle.y = box.L + handle.radius;
			}
		}
		
	}

}