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
		private const MAX_MOVE_TIME:int = 3;
		private const SPEED:Number = 100;
		private const HIT_DELAY:Number = .5;
		public const TOTAL_HEALTH:Number = 100;
		private const HEALTH_DEP:Number = 25;

		
		//------------------------------------------------PROPERTIES
		protected var sprZombiePlaceHolder:Spritemap = new Spritemap(ZOMBIE_PLACEHOLDER, 36, 93);
		protected var startMove:Number;
		protected var endMove:Number;
		protected var rndMovement:Number;
		protected var moveLeft:Number;
		protected var moveRight:Number;
		protected var c:Crate;
		protected var v:Point;
		protected var playerXMiddle:Number;
		public var player:Player;
		public var isCollideLeft:Boolean;
		public var isCollideRight:Boolean;
		public var hitDelay:Number;
		public var myHealth:Number;
		public var myBackground:Image;
		public var origPosX:Number;
		public var aryCZombies:Array;
		public var healthInc:Number;

		
		//------------------------------------------------CONSTRUCTOR
		
		public function Zombie(x:Number,y:Number,myType:String,myPlayer:Player,map:Image) 
		{
			origPosX = x;
			myBackground = map;
			myHealth = TOTAL_HEALTH;
			player = myPlayer;
			this.type = myType;
			sprZombiePlaceHolder.add("zombiePlaceHolder", [1], 100, false);
			super(x, y);
			setHitbox(30, 90);
			
			startMove = 0;
			endMove = 0;
			rndMovement = Math.floor(Math.random() * MAX_MOVE_TIME);
			v = new Point();
			v.x = 0;
			moveLeft = 0;
			moveRight = 0;
			v.x = SPEED;
			hitDelay = HIT_DELAY;
			graphic = sprZombiePlaceHolder;
			aryCZombies = new Array();
			healthInc = 1;

			
		}
		//------------------------------------------------GAME LOOP
		override public function update():void {
			sprZombiePlaceHolder.color = 0xffffff;
			// check if health is depleted
			if (myHealth <= 0) {
				//TODO setup death animation, be sure to allow for animation to complete before he is removed
				//also check if he is near any crates, he will enter the crate if he is beside it
				//possibly have his position move in the opposite direction of him falling, as if is feet are swept
				//from under him, or like rotating him from his center
				world.remove(this);
			}
			
			
			
			sprZombiePlaceHolder.play();
			hitDelay += FP.elapsed;
			//check for distance away from player
			playerXMiddle = player.x + (player.width / 2);
			var distanceFromMe:Number = Math.abs(playerXMiddle - (x + width/2));
			
			//TODO create conditions for movement
			
			if (distanceFromMe < 100) {
				attackMovement();
			}else {
				idleMovement();
			}
			
			v.x = SPEED;
			
			//----------------------------------collision detection
			//crate
			var c:Crate = collide("crate", x, y) as Crate;
			isCollideLeft = false;
			isCollideRight = false;
			if (c != null) {
				if ((c.x <= x + width) && (c.x > x)) {
					isCollideLeft = true;
					//v.x = 0;
					//x = c.x - width;
				}else if ((c.x + c.width >= x)) {
					isCollideRight = true;
				}
			}
			//player
			var p:Player = collide("player", x, y) as Player;
			
			
			if (p) {
				//TODO attack!
				v.x = 0;
			}
			
			//edge of map
			if ((x + width >= myBackground.x +myBackground.width -50)) {
				isCollideLeft = true;
			}
			if ((x <= myBackground.x + 75)) {
				isCollideRight = true;
			}
			
			
			//if player is colliding with more than one
			aryCZombies = [];
			player.collideInto(Zombie.TYPE_TSHIRT_ZOMBIE, player.x, player.y, aryCZombies);
			
			
			
			//--------------------------- being attacked
			if ((isCollideLeft || isCollideRight)) {
				
				
				if (Input.check(Key.SPACE)) {
					if (player.x < x && distanceFromMe <= 25) {
						if (player.FACING_RIGHT) {
							if (hitDelay >= HIT_DELAY) {
								if (aryCZombies[0] == this) {
									myHealth -= HEALTH_DEP;
									knockBack(SPEED);
									hitDelay = 0;
								}
								
							}
						}
						
					}else if (player.x > x && distanceFromMe <= 40) {
						if (player.FACING_LEFT) {
							if (hitDelay >= HIT_DELAY) {
								if (aryCZombies[0] == this) {
									myHealth -= HEALTH_DEP;
									knockBack(SPEED);
									hitDelay = 0;
								}
							}

						}
					}
					
				}
			}else if ((Input.check(Key.SPACE))){
				if (player.x< x && distanceFromMe <= 25) {
					if (hitDelay >= HIT_DELAY) {
						if (aryCZombies[0] == this) {
							myHealth -= HEALTH_DEP;
							sprZombiePlaceHolder.color = 0xff0000;
							hitDelay = 0;
						}
					}
				}else if (player.x> x && distanceFromMe <= 40) {
					if (hitDelay >= HIT_DELAY) {
						if (aryCZombies[0] == this) {
							myHealth -= HEALTH_DEP;
							sprZombiePlaceHolder.color = 0xff0000;
							hitDelay = 0;
						}
					}
				}
			}
			
			super.update();
		}
		
		//------------------------------------------------PUBLIC METHODS
		public override function removed():void {
			x = origPosX;
			// when the zombie is added back to the world he is added with his old position then moved to a the new spawn location
			// when the zombie is removed from the world reset his position back to his old position
			//this could be a problem though, make sure that his old position is where he will actually be respawned
			trace("GOODBYE" + x);
		}
		public override function added():void {
			trace("HELLO" + x);
			myHealth = TOTAL_HEALTH * healthInc;
			trace("MYHEALTH"+myHealth);
			healthInc += 0.5;
		}
		
		public function attackMovement():void {

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
				
				if (moveRight != 0) {
					if (!(endMove >= moveRight)) {
						if (!isCollideLeft) {
							x += v.x * FP.elapsed;
						}
					}
				}else if (moveLeft != 0) {
					if (!(endMove >= moveLeft)) {
						if (!isCollideRight) {
							x -= v.x * FP.elapsed;
						}
					}
				}	
		}
		
		protected function randomBoolean():Boolean
		{
			return Boolean( Math.round(Math.random()) );
		}
		
		public function knockBack(speed:Number):void {
			
			sprZombiePlaceHolder.color = 0xff0000;
			if (player.x > x) {
				x -= (speed * 3) * FP.elapsed;
			}else {
				x += (speed * 3) * FP.elapsed;  
			}
		}
		
		public function collideObstacle():Boolean {
			var c:Crate = collide("crate", x, y) as Crate;
			isCollideLeft = false;
			isCollideRight = false;
			if (c != null) {
				if ((c.x <= x + width) && (c.x > x)) {
					isCollideLeft = true;
					return isCollideLeft;
				}else if ((c.x + c.width >= x)) {
					isCollideRight = true;
					return isCollideRight;
				}
			}
			return false;
		}
		
		public function addHealth(amount:Number) {
			myHealth = TOTAL_HEALTH * amount;
		}
		
	}

}