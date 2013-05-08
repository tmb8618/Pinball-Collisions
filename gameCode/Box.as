package gameCode 
{
	import flash.display.Sprite;
	
	/**
	 * BOX
	 * 
	 * procedurally draws a box
	 **/
	public class Box extends Sprite 
	{
		public var W:Number;	// The width of the box
		public var L:Number;	// The height of the box
		public var color:uint;	// The color of the box
		
		public function Box(W:Number = 40, L:Number = 40, color:uint = 0x0000ff) 
		{
			this.W = W;
			this.L = L;
			this.color = color;
			draw()
		}
		
		// draws a box
		public function draw():void 
		{
			graphics.beginFill(color);
			graphics.drawRect(0, 0, W, L);
			graphics.endFill();
		}
		
	}

}