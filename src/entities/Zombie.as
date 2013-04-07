package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import net.flashpunk.Sfx;
	
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
		[Embed(source = '../../assets/sound/attack.mp3')] public const ATTACK_SND:Class;
		[Embed(source = '../../assets/sound/zombieDeath.mp3')] public const DEATH_SND:Class;
		[Embed(source = '../../assets/sound/alerted1.mp3')] public const ALERTED_ONE_SND:Class;
		[Embed(source = '../../assets/sound/alerted2.mp3')] public const ALERTED_TWO_SND:Class;
		[Embed(source = '../../assets/sound/alerted3.mp3')] public const ALERTED_THREE_SND:Class;

		[Embed(source = '../../assets/zombie.png')] private const ZOMBIES:Class;
		private const ZOMBIE_IDLE:String = "idle";
		public static const TYPE_TSHIRT_ZOMBIE:String = "tshirtZombie";
		private const MAX_MOVE_TIME:int = 3;
		private const SPEED:Number = 100;
		private const HIT_DELAY:Number = .5;
		private const ATTACK_DELAY:Number = 3;
		public const TOTAL_HEALTH:Number = 100;
		private const HEALTH_DEP:Number = 100;

		
		//------------------------------------------------PROPERTIES
		// sounds
		public var sfxAttack:Sfx = new Sfx(ATTACK_SND);
		public var sfxDeath:Sfx = new Sfx(DEATH_SND);
		public var arySfxAlerted:Array;
		
		protected var sprZombiePlaceHolder:Spritemap = new Spritemap(ZOMBIE_PLACEHOLDER, 36, 93);
		protected var sprZombie:Spritemap = new Spritemap(ZOMBIES, 58, 90);
		protected var startMove:Number;
		protected var endMove:Number;
		protected var rndMovement:Number;
		protected var moveLeft:Number;
		protected var moveRight:Number;
		protected var c:Crate;
		public var v:Point;
		protected var playerXMiddle:Number;
		public var player:Player;
		public var isCollideLeft:Boolean;
		public var isCollideRight:Boolean;
		public var hitDelay:Number;
		public var attackDelay:Number;
		public var myHealth:Number;
		public var myBackground:Image;
		public var origPosX:Number;
		public var aryCZombies:Array;
		public var healthInc:Number;
		public var isAttacking:Boolean;
		public var attacked:Boolean;
		
		public var isHit:Boolean = false;
		protected var rndSpeed:int = 0;
		
		

		
		//------------------------------------------------CONSTRUCTOR
		
		public function Zombie(x:Number,y:Number,myType:String,myPlayer:Player,map:Image) 
		{
			arySfxAlerted = new Array();
			arySfxAlerted[0] = new Sfx(ALERTED_ONE_SND);
			arySfxAlerted[1] = new Sfx(ALERTED_TWO_SND);
			arySfxAlerted[2] = new Sfx(ALERTED_THREE_SND);
			origPosX = x;
			myBackground = map;
			myHealth = TOTAL_HEALTH;
			player = myPlayer;
			this.type = myType;
			
			//sprZombie.add("idle", [1], 60, false);
			var aryAnimation:Array = new Array();
			for (var i:int= 0; i < 80; i++) 
			{
				aryAnimation[i] = i;
			}
			sprZombie.add("idle", [100], 60, false);
			sprZombie.add("walk", aryAnimation, 60, true);
			sprZombie.add("raiseArms", [103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131], 24, false);
			sprZombie.add("death", [172, 173, 174, 175, 176, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199], 100, false);
			var aryAnimation1:Array = new Array();
			var ex:int = 0;
			for (var g:int= 165; g < 173; g++) 
			{
				aryAnimation1[ex] = g;
				ex++;
			}
			sprZombie.add("attack", aryAnimation1, 100, false);
			
			super(x, y);
			setHitbox(40, 90);
			isAttacking = false;
			startMove = 0;
			endMove = 0;
			rndMovement = Math.floor(Math.random() * MAX_MOVE_TIME);
			v = new Point();
			v.x = 0;
			moveLeft = 0;
			moveRight = 0;
			rndSpeed = SPEED + Math.floor(Math.random() * 80);
			v.x = rndSpeed;
			trace(v.x);
			hitDelay = HIT_DELAY;
			attackDelay = ATTACK_DELAY;
			graphic = sprZombie;
			aryCZombies = new Array();
			healthInc = 1;
			attacked = false;
			sfxDeath.volume = 8;
		}
		//------------------------------------------------GAME LOOP
		override public function update():void {
			if (x > player.centerX) {
				sprZombie.flipped = true;
			}else {
				sprZombie.flipped = false;
			}
			
			//reset some properties
			
			
			sprZombie.color = 0xffffff;
			// check if health is depleted
			if (myHealth <= 0) {
				isAttacking = false;
				sfxDeath.play();
				sprZombie.play("death");
				if(sprZombie.complete)world.remove(this);
			}
			// do not allow any thing else to happen when the zombie is dead
			// this is to prevent anything else from trying to take place 
			if (!myHealth <= 0) {
				hitDelay += FP.elapsed;
				//check for distance away from player
				playerXMiddle = player.x + (player.width / 2);
				var distanceFromMe:Number = Math.abs(playerXMiddle - (x + width/2));
				if (sprZombie.currentAnim != "death" || sprZombie.currentAnim != "attack") {
					if (distanceFromMe < 300) {
						if (isAttacking) {
							attacked = true;
						}
						if (attacked) {
							sfxAttack.play();
							sprZombie.play("attack");
							if (sprZombie.complete) {
								attacked = false;
							}
						}else {
							if (sprZombie.currentAnim == "idle") {
								var rndSound:int = Math.floor(Math.random() * 3);
								arySfxAlerted[rndSound].play();
								sprZombie.play("raiseArms");
							} 
							
							if ((sprZombie.currentAnim == "walk") ||
								(sprZombie.complete && sprZombie.currentAnim == "raiseArms") ||
								(sprZombie.currentAnim == "attack")) {
									
								if(distanceFromMe > 75 || player.touchingGround)attackMovement();
								
							}
						}
						
						//attackMovement();
					}else {
						sprZombie.play("idle");
						
						//if(sprZombie.currentAnim != "walk")sprZombie.play("idle");
						if (distanceFromMe > 600) idleMovement();
						
						
					}				
				}
				isAttacking = false;
				
				v.x = rndSpeed;
				
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
				// colliding with player
				var p:Player = collide("player", x, y) as Player;
				
				// ----------attacking
				attackDelay += FP.elapsed;
				if (p) {
					
					if (attackDelay > ATTACK_DELAY) {
						isAttacking = true;
						attackDelay = 0;
					}
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
				
				if (isHit) {
					myHealth -= HEALTH_DEP;
					sprZombie.color = 0xff0000;
					hitDelay = 0;
					isHit = false;
					knockBack(SPEED*4);
				}
			}
			super.update();
		}
		
		//------------------------------------------------PUBLIC METHODS
		public override function removed():void {
			x = origPosX;
			this.visible = false;
			trace("GOODBYE" + x);
		}
		
		public override function added():void {
			trace("HELLO" + x);
			this.visible = true;
			myHealth = TOTAL_HEALTH * healthInc;
			trace("MYHEALTH"+myHealth);

			healthInc += 0.2;
		}
		
		public function attackMovement():void {
			if (playerXMiddle < centerX) {
				sprZombie.flipped = true;
				if (!isCollideRight) {
					x -= v.x * FP.elapsed;
				}
				
			}else {
				if (!isCollideLeft) {
					x += v.x * FP.elapsed;
				}
				
			}
			
			sprZombie.play("walk");
			
			
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
						moveRight = Math.floor(Math.random() * 4);
						moveLeft = 0;
					}else {
						moveLeft = Math.floor(Math.random() * 4);
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
						sprZombie.flipped = true;
						if (!isCollideRight) {
							x -= v.x * FP.elapsed;
						}
					}
				}
				sprZombie.play("walk");
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
		
		public function addHealth(amount:Number):void {
			myHealth = TOTAL_HEALTH * amount;
		}
		
	}

}