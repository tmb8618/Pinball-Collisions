package gameCode 
{
	import flash.display.Sprite;
	
	public class Spinner extends Sprite 
	{
		public var radius:Number;
		public var thickness:Number;
		public var color:uint;
		public var vertices:Array;
		public var vr:Number = 0;
		public var angle:Number = 0;
		public var score:int;
		
		public function Spinner(posX:Number, posY:Number, r:Number, thick:Number, color:uint = 0X000000 points:int = 100) 
		{
			this.x = posX;
			this.y = posY;
			radius = r;
			thickness = thick;
			this.color = color;
			
			vertices = new Array();
			
			calcVertex();
			draw();
		}
		
		public function draw():void 
		{
			
			graphics.lineStyle(1, color);
			
			for (var i:int = 1; i <= 4; i++)
			{
				graphics.moveTo(vertices[0].x, vertices[0].y);
				graphics.lineTo(vertices[i].x, vertices[i].y);
			}
			
		}
		
		public function calcVertex():void 
		{
			var theta:Number = 0
			
			vertices.push(new Vertex(0, 0));
			for (var i:int = 0; i < 4; i++)
			{
				vertices.push(new Vertex(radius * Math.cos(theta), radius * Math.sin(theta)));
				theta += Math.PI / 2;
			}
		}
		
	}

}