package gameCode 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.net.*;
	import flash.geom.ColorTransform;
	import flash.text.engine.SpaceJustifier;
	import flash.text.engine.EastAsianJustifier;
	import gameCode.Plunger;

	public class MainApp extends Sprite 
	{
		
		private var ti:Number;							//inital time. used to calculate dt
		private var tf:Number;							//final time. also used in dt calcluation
		private var dt:Number;							//Delta Time. Change in time from the final and inital.
		private var ANIMATION_RATE:int = 24;			//The number of frames per second. shouldn't matter too much, cuz the physics should be the same every time.
		
		private var titleText:TextField;				//The pitiful title text
		private var startText:TextField;				//Indicates which sprite button is the start
		private var creditsText:TextField;				//Same thing, but with credits
		private var instructionsText:TextField;			//again, the same, but for the how to play.
		private var newScreenText:TextField;			//Where the text for the credits and instructions is displayed
		private var startButton:Sprite;					//when pressed, will begin a game of pinball
		private var instructionsButton:Sprite;			//when pressed, will display the instuctions in the newScreenText box
		private var creditsButton:Sprite;				//when pressed, will display the credits for the pinball game in the newScreenBox
		private var buttonBox:Sprite;					//where the pause menu is 'stored.' all the ui while paused happens here.
		private var pauseButton:Sprite;					//press this to pause the game. brings up the pause screen.
		private var pauseText:TextField;				//Lets People know where the pause button is. not always obvious.
		private var resumeButton:Sprite;				//in the pause menu, press this to continue playing pinball
		private var resumeText:TextField;				//Tells you what the resume button actually does.
		private var quitButton:Sprite;					//in the pause menu, press this to skip back to the title screen, landing on the credits.
		private var quitText:TextField;					//tells you wha the quit button actually does.
		private var UIArray:Array;						//When the game ends, this will make it easy to clear everything.

		public var ball:Ball;							//The Ball! very important. does what it says. makes a ball. further explained in ball class
		private var plunger:Plunger;					//Plunger. works great, just not with my collision code.
		public var onStart:Boolean = false;
		
		private var collide:Boolean = false;			//part of a solid state machine. prevents the ball from doing one of thoes megaclip things where it just jumps back and forth all the time

		private var lives:int = 10;						//called lives becasue 'balls' is a little unclassy. the number of balls you have left. Most important.		
		private var score:Number = 0;					//the 2nd most important part of pinball, aside from survival. Keeps track of your score.
		private var scoreBox:TextField;					//a place to display and show the score while playing.
		
		private var flipperRight:Flipper;				//the flippers. universal in pinball. 
		private var flipperLeft:Flipper;				//second flipper.
		private var leftDown:Boolean = false;			//'helper' booleans for allowing both flippers to be pushed at the same time
		private var rightDown:Boolean = false;
		
		public var stuffArray:Array = new Array(); 		//Where are the fun pinball traps go. fun fun fun.
		
		public function MainApp()
		{
			stuffArray.push(new Array()); //Add four arrays to the stuff array.
			stuffArray.push(new Array()); //this will be used when checking collisions,
			stuffArray.push(new Array()); //so everything doesn't get checked every frame.
			stuffArray.push(new Array()); //thats a little processing intensive.
			
			UIArray = new Array();
						
			titleScreen();
		}
		
		/*
			Draws all of the UI pertaining to the title screen.
		*/
		
		public function titleScreen()
		{
			startButton = new Sprite();
			startButton.graphics.beginFill(0x2FC231);
			startButton.graphics.lineStyle(2, 0x000000);
			startButton.graphics.drawRect(0, 0, 100, 40);
			startButton.x = 40;
			startButton.y = 590;
			startButton.graphics.endFill();
			UIArray.push(startButton);
			addChild(startButton);
			
			instructionsButton = new Sprite();
			instructionsButton.graphics.beginFill(0xFF0000);
			instructionsButton.graphics.lineStyle(2, 0x000000);
			instructionsButton.graphics.drawRect(0, 0, 100, 40);
			instructionsButton.x = 40;
			instructionsButton.y = 640;
			instructionsButton.graphics.endFill();
			UIArray.push(instructionsButton);
			addChild(instructionsButton);
			
			creditsButton = new Sprite();
			creditsButton.graphics.beginFill(0xFFFF00);
			creditsButton.graphics.lineStyle(2, 0x000000);
			creditsButton.graphics.drawRect(0, 0, 100, 40);
			creditsButton.x = 40;
			creditsButton.y = 690;
			creditsButton.graphics.endFill();
			UIArray.push(creditsButton);
			addChild(creditsButton);
			
			newScreenText = new TextField();
			newScreenText.x = 100;
			newScreenText.y = 100;
			newScreenText.height = 200;
			newScreenText.width = 500;
			UIArray.push(newScreenText);
			addChild(newScreenText);
			
			titleText = new TextField();
			titleText.width = 400;
			titleText.height = 40;
			titleText.selectable = false;
			titleText.text = "PINBALL";
			UIArray.push(titleText);
			addChild(titleText);
			
			startText = new TextField();
			startText.text = "Start Game";
			startText.x = 150;
			startText.y = 600;
			startText.selectable = false;
			UIArray.push(startText);
			addChild(startText);
			
			instructionsText = new TextField();
			instructionsText.text = "Instructions";
			instructionsText.x = 150;
			instructionsText.y = 650;
			UIArray.push(instructionsText);
			addChild(instructionsText);
			
			creditsText = new TextField();
			creditsText.text = "Credits";
			creditsText.x = 150;
			creditsText.y = 700;
			UIArray.push(creditsText);
			addChild(creditsText);
			
			instructionsButton.addEventListener(MouseEvent.CLICK, drawInstructionsScreen);
			creditsButton.addEventListener(MouseEvent.CLICK, drawCreditsScreen);
			startButton.addEventListener(MouseEvent.CLICK, beginGame);

		}
				
		public function drawInstructionsScreen(e:Event)
		{
			newScreenText.text = "In pinball, the objective is to play the game for as long as possible and score points. \nPress the 'z' button to hit the left flipper and the '/' button to hit the left flipper. \nKeep the ball from falling into the pit. \nScore points by hitting objects in the world. \nClick on the yellow button in the top right corner to pause the game. It is labled with a capital P.";
			
		}
		
		public function drawCreditsScreen(e:Event)
		{
			newScreenText.text = "Programming, design, thought process by Ian Furry and Tyler Brogna. \nCredit goes Seb Lee-Delisle. That's guy's a genius. seb.ly \nCredit also goes to Chad Berchek, for his awesome 2D collision walkthrough. vobarian.com \nAlso to Joe, who showed me Chad's paper in the first place, and was generally helpful. \nAlso to Prof Schwartz, who helped even when it was clear that I was just being stupid. \nFinally the Adobe Actionscript API. The best help and the worst help all at the same time.";
		}
		
		public function beginGame(e:Event):void 
		{
			clearArrays();
			
			addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			addEventListener(KeyboardEvent.KEY_UP, keyUp);
			stage.focus = this;
			
			pauseButton = new Sprite();
			pauseButton.graphics.lineStyle(1, 0x000000);
			pauseButton.graphics.beginFill(0xFFFF00, .5);
			pauseButton.graphics.drawRect(5, 5, 25, 25);
			addChild(pauseButton);
			pauseButton.addEventListener(MouseEvent.CLICK, pause);
			UIArray.push(pauseButton);
			
			pauseText = new TextField();
			pauseText.x += 30;
			pauseText.y += 5;
			pauseText.width = 15;
			pauseText.height = 15;
			pauseText.text = "P";
			addChild(pauseText);
			UIArray.push(pauseText);
			
			buttonBox = new Sprite();
			buttonBox.graphics.lineStyle(1, 0x000000);
			buttonBox.graphics.beginFill(0xFAF7C8, .5);
			buttonBox.x += stage.stageWidth / 4;
			buttonBox.y += stage.stageHeight / 4
			buttonBox.graphics.drawRect(0, 0, stage.stageWidth / 2, stage.stageHeight / 2);
			buttonBox.graphics.endFill();
			
			resumeButton = new Sprite();
			resumeButton.graphics.lineStyle(1, 0x000000);
			resumeButton.graphics.beginFill(0x2FC231);
			resumeButton.x += buttonBox.x + (buttonBox.width / 6);
			resumeButton.y += buttonBox.y + (buttonBox.height / 4);
			resumeButton.graphics.drawRect(0,0, buttonBox.width / 4, buttonBox.height / 6);
			resumeButton.graphics.endFill();
			
			resumeText = new TextField();
			resumeText.x += resumeButton.x + resumeButton.width;
			resumeText.y += resumeButton.y;
			resumeText.width = resumeButton.width * 1.5;
			resumeText.height = resumeButton.height;
			resumeText.text = "CONTINUE GAME";
			
			quitButton = new Sprite();
			quitButton.graphics.lineStyle(1, 0x000000);
			quitButton.graphics.beginFill(0xC22F58);
			quitButton.x += resumeButton.x;
			quitButton.y += resumeButton.y + (buttonBox.height / 4);
			quitButton.graphics.drawRect(0,0, buttonBox.width / 4, buttonBox.height / 6);
			quitButton.graphics.endFill();
			
			quitText = new TextField();
			quitText.x += quitButton.x + quitButton.width;
			quitText.y += quitButton.y;
			quitText.width = quitButton.width * 1.5;
			quitText.height = quitButton.height;
			quitText.text = "RETURN TO MENU";
			
			scoreBox = new TextField();
			scoreBox.x += 50;
			scoreBox.y += 750;
			scoreBox.width = 100;
			scoreBox.height = 50;
			addChild(scoreBox);
			
			
			plunger = new Plunger(40, 80, 25, 400, 8000);
			plunger.x += 580;
			plunger.y += 650;
			addChild(plunger);
			plunger.activate();
			stuffArray[3].push(plunger);
						
			ball = new Ball(600, 600, 15, 0X550055);
			addChild(ball);
			
			/*SET 1*/
			
			var wall:Wall = new Wall(5, new Vect(650, -100), new Vect(650, 1000));
			addChild(wall);
			wall.init();
			stuffArray[1].push(wall);
			stuffArray[3].push(wall);

			var wall1:Wall = new Wall(5, new Vect(550, 1000), new Vect(550, 200));
			addChild(wall1);
			wall1.init();
			stuffArray[1].push(wall1);
			stuffArray[3].push(wall1);
						
			var wall2:Wall = new Wall(5, new Vect(600, 0), new Vect(650, 150));
			addChild(wall2);
			wall2.init();
			stuffArray[1].push(wall2);
			
			var wall2_1:Wall = new Wall(5, new Vect(100, 0), new Vect(0, 150));
			addChild(wall2_1);
			wall2_1.init();
			stuffArray[0].push(wall2_1);
			
			/*SET 2*/
			
			var wall3:Wall = new Wall(3, new Vect(75, 100), new Vect(175, 75));
			addChild(wall3);
			wall3.init();
			stuffArray[0].push(wall3);
			
			var wall4:Wall = new Wall(3, new Vect(175, 75), new Vect(50, 200));
			addChild(wall4);
			wall4.init();
			stuffArray[0].push(wall4);
			
			var wall5:Wall = new Wall(3, new Vect(50, 200), new Vect(75, 100));
			addChild(wall5);
			wall5.init();
			stuffArray[0].push(wall5);
			
			/*SET 3*/
			
			var wall6:Wall = new Wall(3, new Vect(400, 75), new Vect(500, 100));
			addChild(wall6);
			wall6.init();
			stuffArray[1].push(wall6);
			
			var wall7:Wall = new Wall(3, new Vect(500, 100), new Vect(550, 200));
			addChild(wall7);
			wall7.init();
			stuffArray[1].push(wall7);
			
			var wall8:Wall = new Wall(3, new Vect(550, 200), new Vect(400, 75));
			addChild(wall8);
			wall8.init();
			stuffArray[1].push(wall8);

			/*SET4*/
			
			var bumper1:Bumper = new Bumper(212, 175, 25, 1.5, 0x000000);
			stuffArray[0].push(bumper1);
			addChild(bumper1);
			
			var bumper2:Bumper = new Bumper(363, 175, 25, 1.5, 0x000000);
			stuffArray[0].push(bumper2);
			addChild(bumper2);
			
			var bumper3:Bumper = new Bumper(287, 275, 25, 1.5, 0x000000);
			stuffArray[0].push(bumper3);
			stuffArray[1].push(bumper3);
			addChild(bumper3);
			
			var bumper4:Bumper = new Bumper(150, 400, 25, 1.5, 0x000000);
			stuffArray[0].push(bumper4);
			stuffArray[2].push(bumper4);
			addChild(bumper4);
			
			var bumper5:Bumper = new Bumper(425, 400, 25, 1.5, 0x000000);
			stuffArray[1].push(bumper5);
			stuffArray[3].push(bumper5);
			addChild(bumper5);
			
			/*SET 5*/
			
			var wall9:Wall = new Wall(3, new Vect(550, 350), new Vect(512, 388));
			addChild(wall9);
			wall9.init();
			stuffArray[1].push(wall9);
			stuffArray[3].push(wall9);
			
			var wall10:Wall = new Wall(3, new Vect(512, 388), new Vect(550, 425));
			addChild(wall10);
			wall10.init();
			stuffArray[3].push(wall10);
			
			var wall11:Wall = new Wall(3, new Vect(0, 350), new Vect(37, 388));
			addChild(wall11);
			wall11.init();
			stuffArray[0].push(wall11);
			
			var wall11_1:Wall = new Wall(3, new Vect(0, 425), new Vect(37, 388));
			addChild(wall11_1);
			wall11_1.init();
			stuffArray[0].push(wall11_1);

			
			var wall12:Wall = new Wall(3, new Vect(100, 600), new Vect(200, 700));
			addChild(wall12);
			wall12.init();
			stuffArray[2].push(wall12);
			
			var wall13:Wall = new Wall(3, new Vect(500, 600), new Vect(400, 700));
			addChild(wall13);
			wall13.init();
			stuffArray[3].push(wall13);
			
			var obstacle1:Obstacle = new Obstacle(6, 40, 0xCC0000);
			obstacle1.init();
			for (var m:int = 0; m < obstacle1.walls.length; m++)
			{
				addChild(obstacle1.walls[m]);
				obstacle1.walls[m].x += 210;
				obstacle1.walls[m].y += 550;
				stuffArray[0].push(obstacle1.walls[m]);
				stuffArray[2].push(obstacle1.walls[m]);
			}
			
			var obstacle2:Obstacle = new Obstacle(6, 40, 0xCC0000);
			obstacle2.init();
			for (var l:int = 0; l < obstacle2.walls.length; l++)
			{
				addChild(obstacle2.walls[l]);
				obstacle2.walls[l].x += 420;
				obstacle2.walls[l].y += 550;
				stuffArray[1].push(obstacle2.walls[l]);
				stuffArray[3].push(obstacle2.walls[l]);
			}

			
			flipperLeft = new Flipper(3, new Vect(200, 700), new Vect(300, 700), 100, 100, 1, Math.PI / 6);
			addChild(flipperLeft);
			flipperLeft.init();
			stuffArray[2].push(flipperLeft);
			stuffArray[3].push(flipperLeft);
			
			flipperRight = new Flipper(3, new Vect(400, 700), new Vect(300, 700), 100, 100, -1, Math.PI / 6);
			addChild(flipperRight);
			flipperRight.init();
			stuffArray[3].push(flipperRight);
			stuffArray[2].push(flipperRight);
			
			ti = getTimer();
			addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		public function pause(e:Event)
		{
			removeEventListener(Event.ENTER_FRAME, update);
			pauseButton.removeEventListener(MouseEvent.CLICK, pause);
			
			addChild(buttonBox);
			addChild(resumeButton);
			addChild(resumeText);
			addChild(quitButton);
			addChild(quitText);
			UIArray.push(buttonBox);
			UIArray.push(resumeButton);
			UIArray.push(resumeText);
			UIArray.push(quitButton);
			UIArray.push(quitText);
			
			resumeButton.addEventListener(MouseEvent.CLICK, unpause);
			quitButton.addEventListener(MouseEvent.CLICK, quitGame);			
		}
		
		public function unpause(e:Event)
		{
			addEventListener(Event.ENTER_FRAME, update);
			
			removeChild(buttonBox);
			removeChild(resumeButton);
			removeChild(resumeText);
			removeChild(quitButton);
			removeChild(quitText);
			
			for (var i:int = 0; i < 5; i++)
			{
				UIArray.pop();
			}
			
			pauseButton.removeEventListener(MouseEvent.CLICK, unpause);
			pauseButton.addEventListener(MouseEvent.CLICK, pause);
			stage.focus = this;
			ti = getTimer();
		}
		
		public function quitGame(e:Event)
		{
			clearArrays();
			score = 0;
			titleScreen();
			drawCreditsScreen(new Event(MouseEvent.CLICK));
		}

		
		private function keyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 90) // "z"
			{
				leftDown = true;
			}
			if (e.keyCode == 191) // "/"
			{
				rightDown = true;
			}
		}
		
		private function keyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == 90) // "z"
			{
				leftDown = false;
			}
			if (e.keyCode == 191) // "/"
			{
				rightDown = false;
			}
		}
		
		/*
			The update method. uses deltaTime to update the things that need to be updated.
			The flippers come first. Important when the ball collides against them.
			then the ball. it checks the location of the ball to determine which set of objects to collision check.
			after that, the ball actually gets updated.
		*/
		
		public function update(e:Event):void
		{
			
			tf = getTimer();
			dt = (tf - ti)/1000;
			ti = tf;
			
			collide = false;
			
			flipperLeft.update(leftDown, dt);
			flipperRight.update(rightDown, dt);
			
			collideCheck(0);
			collideCheck(1);
			collideCheck(2);
			collideCheck(3);
			
			if (ball.y > stage.stageHeight / 2)
			{
				collideCheck(0);
				collideCheck(1);				
			}
			else
			{
				collideCheck(2);
				collideCheck(3);
			}
						
			ball.update(dt);
			
			
			if(plunger.collideWith(ball))
			{
				ball.velocity.y = -1;
				ball.y = plunger.y - ball.radius;
				onStart = true;
			}
			else
			{
				onStart = false;
			}
			
			plunger.update(dt);
			
			if (ball.y > stage.stageHeight)
			{
				lives--;
				ball.x = stage.stageWidth / 2;
				ball.y = 0;
			}
			
			scoreBox.text = "score" + score;
			
		}
		
		/*
			This method is sent which portion of the array needs to be checked against for collisions.
			The array is broken up into the four quardrants of the screen, and it checks everything that could be even remotely
			considered in that part of the screen.
			if there is a collision, the ball is bounced off by being given a new velocity
		*/
				
		public function collideCheck(counter:int)
		{
			for (var i:int = 0; i < stuffArray[counter].length; i++)
			{
				if(stuffArray[counter][i] is Wall)
				{
					if (stuffArray[counter][i].collide(ball, dt))
					{
						trace("wall");
						ball.velocity = stuffArray[counter][i].reflect(ball);
					}
				}
					
				if(stuffArray[counter][i] is Bumper)
				{
					if (stuffArray[counter][i].collide(ball))
					{
						trace("bumper");
						
						ball.velocity = stuffArray[counter][i].bounce(ball);
						score += stuffArray[counter][i].score;
					}
				}
				
				if (stuffArray[counter][i] is Flipper)
				{
					if (stuffArray[counter][i].collide(ball, dt))
					{
						trace("flipper");
						ball.velocity = stuffArray[counter][i].reflect(ball);
					}
				}
				/*if (stuffArray[counter][i] is Obstacle)
				{
					for (var j:int = 0; j < stuffArray[counter][i].walls.length; j++)
					{
						if (stuffArray[counter][i].walls[j].collide(ball, dt))
						{
							ball.velocity = stuffArray[counter][i].reflect(ball);
						}
					}
				}*/
			}

		}
		
		/*
			Clears all the stuff from the screen. Makes switching between screen and menus easier when
			removing everything can be done on a whim.
		*/
		
		public function clearArrays()
		{
			for (var i:int = 0; i < stuffArray.length; i++)
			{
				for (var j:int = stuffArray[i].length - 1; j >= 0; j--)
				{
					if(this.contains(stuffArray[i][j]))
					{
						removeChild(stuffArray[i][j]);
					}
					stuffArray[i].pop();
				}
			}
			
			for (var k:int = UIArray.length - 1; k >= 0; k--)
			{
				removeChild(UIArray[k]);
				UIArray.pop();
			}
			
			if(ball != null && this.contains(ball))
			{
				removeChild(ball);
			}
		}
		
		/*
			Send a vector, get its magnitude
		*/
		
		public static function getMagnitude(vect:Vect):Number
		{
			return new Number(Math.sqrt(Math.pow(vect.x, 2) +
										 Math.pow(vect.y, 2)));
		}
		
		/*
			Gets the unit of the vector given
		*/
		
		public static function unitize(vect:Vect):Vect
		{
			var magnitude:Number = getMagnitude(vect);
			return new Vect(vect.x / magnitude, vect.y / magnitude);
		}
		
		/*
			gets the unit normal of a vector. 
		*/
		
		public static function getNormal(vect:Vect):Vect
		{
			var magnitude:Number = getMagnitude(vect);
			return new Vect(-vect.y / magnitude, vect.x / magnitude);
		}
		
		/*
			Send two vectors, get sent the dot product
		*/
		
		public static function dotProduct(project:Vect, plane:Vect):Number
		{
			return new Number((project.x * plane.x) + (project.y * plane.y));
		}
		
		//gets the projected vetor of two vectors, in vector form
		
		public static function projectVector(project:Vect, plane:Vect):Vect
		{
			var prod:Number = dotProduct(project, plane);
			
			var magSqr =  Math.pow(plane.x, 2) + Math.pow(plane.y, 2);
			
			return new Vect(plane.x * (prod / magSqr), plane.y * (prod / magSqr));			
		}
		
		/*
			Send a vector and a number, returns the two multiplied together
		*/
		
		public static function multiplyVector(unitVect:Vect, num:Number):Vect
		{
			return new Vect(unitVect.x * num, unitVect.y * num);
		}
	}
}