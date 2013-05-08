package gameCode 
{
	
	public class ConvexWall extends Wall 
	{
		
		public function ConvexWall(length:Number, width:Number, angle:Number=0, color:uint=0x000000) 
		{
			super(length, width, angle, color);
		}
		
		override protected function drawWall(color:uint = 0x000000)
		{
			graphics.beginFill(color);
			
			graphics.lineStyle(1, color);
			
			graphics.moveTo(0, 0);
			
			graphics.lineTo(vertices[1].x, vertices[1].y);
			graphics.curveTo(vertices[2].x, vertices[2].y, vertices[3].x, vertices[3].y);
			graphics.lineTo(0, 0);
			
			graphics.endFill();
			
			this.rotation = angle;
		}
		
	}

}