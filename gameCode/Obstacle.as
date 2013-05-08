package gameCode
{
	import flash.display.Sprite;
	
	public class Obstacle extends Sprite 
	{
		private var radius:Number;     // radius from center of polygon
		private var sides:Number;      // number of sides
		private var color:uint;        // color of polygon
		private var thickness:Number;  // thickness of outer line
		private var vertices:Array;    // array of polygon vertices
		private var score:int;
		
		public var walls:Array = new Array();
		
		public function Obstacle(sides:int, radius:Number=40, color:uint=0x000000) 
		{
			this.sides = sides;
			this.radius = radius;
			this.color = color;
			score = 0;
			vertices = new Array(); 
			init();
		}
		
		public function init():void {
			makeVertices();
			renderVertices();
		}
		
		// calculate and store polygon vertices:
		public function makeVertices():void {
			vertices.push(new Vect(radius,0)); // start polygon on x=radius and y=0 from center
			
			// calculate vertices for angles between 0 and 360, not inclusive--already have 1st vertex, which closes polygon)
			for (var side:uint=1; side < sides; side++) {
				var angle:Number = 2*Math.PI*side / sides; // how many angle increments from 0
				vertices.push(new Vect(radius*Math.cos(angle),radius*Math.sin(angle)));
			}
		}
		
		// render the polygon:
		public function renderVertices():void 
		{
			for (var i:int = 1; i < vertices.length; i++)
			{
				var wall:Wall = new Wall(10, vertices[i - 1], vertices[i]);
				
				walls.push(wall);
				addChild(wall);
				wall.init();
			}
			
			wall = new Wall(4, vertices[vertices.length - 1], vertices[0]);
			walls.push(wall);
			addChild(wall);
			wall.init();
		}		
	}
}