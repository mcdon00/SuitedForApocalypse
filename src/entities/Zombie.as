package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author ...
	 */
	public class Zombie extends Entity
	{
		
		//------------------------------------------------CONSTANTS
		[Embed(source = '../../assets/zombiePlaceHolder.png')] private const ZOMBIE_PLACEHOLDER:Class;
		private const ZOMBIE_IDLE:String = "idle";
		public static const TYPE_TSHIRT_ZOMBIE:String = "tshirtZombie";
		private const MAX_MOVE_TIME:int = 50;
		private const SPEED:Number = 100;
		
		//------------------------------------------------PROPERTIES
		protected var sprZombiePlaceHolder:Spritemap = new Spritemap(ZOMBIE_PLACEHOLDER, 36, 93);
		protected var startMove:Number;
		protected var endMove:Number;
		protected var rndMovement:Number;
		protected var moveLeft:Number;
		protected var moveRight:Number;
		protected var c:Crate;
		protected var v:Point;
		protected var stoppedLeft:Boolean; 
		protected var stoppedRight:Boolean;
		protected var playerXMiddle:Number;
		protected var player:Entity;
		protected var isCollideLeft:Boolean;
		protected var isCollideRight:Boolean;
		
		//------------------------------------------------CONSTRUCTOR
		
		public function Zombie(x:Number,y:Number,myType:String,myPlayer:Entity) 
		{
			
			player = myPlayer;
			this.type = myType;
			sprZombiePlaceHolder.add("zombiePlaceHolder", [1], 100, false);
			super(x, y, sprZombiePlaceHolder);
			setHitbox(30, 90);
			
			startMove = 0;
			endMove = 0;
			rndMovement = Math.floor(Math.random() * MAX_MOVE_TIME);
			v = new Point();
			v.x = 0;
			moveLeft = 0;
			moveRight = 0;
			v.x = SPEED;
			
		}
		//------------------------------------------------GAME LOOP
		override public function update():void {
			sprZombiePlaceHolder.play();
			//check for distance away from player
			playerXMiddle = player.x + (player.width / 2);
			var distanceFromMe:Number = Math.abs(playerXMiddle - x);
			
			
			
			//TODO create conditions for movement
			//TODO fanout on spawn
			if (distanceFromMe < 200) {
				attackMovement();
			}else {
				idleMovement();
			}
			
			
			
			v.x = SPEED;
			
			//collision detection
			var c:Crate = collide("crate", x, y) as Crate;
			isCollideLeft = false;
			isCollideRight = false;
			if (c != null) {
				
				if ((c.x <= x + width)&& (c.x > x)) {
					isCollideLeft = true;
				}else if ((c.x + c.width >= x)) {
					isCollideRight = true;
				}
			}
			
		
			var p:Player = collide("player", x, y) as Player;
			
			
			if (p) {
				//TODO attack!
				v.x = 0;
			}
			
			super.update();
		}
		
		//------------------------------------------------PUBLIC METHODS
		public function attackMovement():void{
			if (playerXMiddle < x) {
				if (!isCollideRight) {
					x -= v.x * FP.elapsed;
				}

			}else {
				if (!isCollideLeft) {
					x += v.x * FP.elapsed;
				}
			}
		}
		public function idleMovement():void{
			//randomly move zombie while in idle state;
			
				startMove += FP.elapsed;
				endMove += FP.elapsed;
			
				
				if (startMove >= rndMovement) {
					rndMovement = Math.floor(Math.random() * MAX_MOVE_TIME);
					
					startMove = 0;
					endMove = 0;
					if (randomBoolean()) {
						moveRight = Math.floor(Math.random() * 2);
						moveLeft = 0;
					}else {
						moveLeft = Math.floor(Math.random() * 2);
						moveRight = 0;
					}
					
				}
				//TODO add collision detection using the isCollides
				if (moveRight != 0) {
					c = collide("crate", x, y) as Crate;
					if (!(endMove >= moveRight)) {
						stoppedRight = false;
						if (c) {
							stoppedRight = true;
							v.x = 0;
						}
						
						if (stoppedLeft) {
							v.x = SPEED;
						}
						
						x += v.x * FP.elapsed;
					}
				}else if (moveLeft != 0) {
					c = collide("crate", x, y) as Crate;
					if (!(endMove >= moveLeft)) {
						stoppedLeft = false;
						if (c) {
							stoppedLeft = true;
							v.x = 0;
						}
						
						if (stoppedRight) {
							v.x = SPEED;
						}
						
						x -= v.x * FP.elapsed;
					}
				}
			
			
		}
		
		protected function randomBoolean():Boolean
		{
			return Boolean( Math.round(Math.random()) );
		}
		 
		
	}

}