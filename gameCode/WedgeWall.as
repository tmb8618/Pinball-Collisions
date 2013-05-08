package gameCode 
{
	
	public class WedgeWall extends Wall 
	{
		
		public function WedgeWall(length:Number, width:Number, angle:Number=0, color:uint=0x000000) 
		{
			super(length, width, angle, color);
		}
		
		override protected function calcVertex(length:Number, width:Number)
		{
			vertices.push(new Vertex(0, 0));
			vertices.push(new Vertex(width, 0));
			vertices.push(new Vertex(0, length));
		}
		
	}

}