package gameCode 
{
	
	public class ConcaveWall extends Wall 
	{
		
		public function ConcaveWall(length:Number, width:Number, angle:Number=0, color:uint=0x000000) 
		{
			super(length, width, angle, color);
		}
		
		override protected function drawWall(color:uint = 0x000000)
		{
			graphics.beginFill(color);
			
			graphics.lineStyle(1);
			
			graphics.moveTo(0, 0);
			
			graphics.lineTo(vertices[1].x, vertices[1].y);
			graphics.curveTo(vertices[0].x, vertices[0], vertices[3].x, vertices[3].y);
			graphics.lineTo(0, 0);
			
			graphics.endFill();
			
			this.rotation = angle;
		}
		
	}

}