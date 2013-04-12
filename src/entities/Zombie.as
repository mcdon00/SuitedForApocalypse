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
		// sound contsants
		[Embed(source = '../../assets/sound/attack.mp3')] public const ATTACK_SND:Class;
		[Embed(source = '../../assets/sound/zombieDeath.mp3')] public const DEATH_SND:Class;
		[Embed(source = '../../assets/sound/alerted1.mp3')] public const ALERTED_ONE_SND:Class;
		[Embed(source = '../../assets/sound/alerted2.mp3')] public const ALERTED_TWO_SND:Class;
		[Embed(source = '../../assets/sound/alerted3.mp3')] public const ALERTED_THREE_SND:Class;
		// sprite sheet contstants
		[Embed(source = '../../assets/zombie.png')] private const ZOMBIES:Class;
		// contstant for if the zombie is idle
		private const ZOMBIE_IDLE:String = "idle";
		//static constant for the type of zombie this is
		public static const TYPE_TSHIRT_ZOMBIE:String = "tshirtZombie";
		// constant for the time delay for idle movement
		private const MAX_MOVE_TIME:int = 3;
		// constant for the speed the zombie travels at
		private const SPEED:Number = 100;
		// contant for the delay in being hit
		private const HIT_DELAY:Number = .5;
		// contant for the delay in attacking
		private const ATTACK_DELAY:Number = 3;
		//Zombie's total health
		public const TOTAL_HEALTH:Number = 150;
		// constant for how much to depricate the health
		private const HEALTH_DEP:Number = 100;

		
		//------------------------------------------------PROPERTIES
		// onjects for sounds
		private var sfxAttack:Sfx = new Sfx(ATTACK_SND);
		private var sfxDeath:Sfx = new Sfx(DEATH_SND);
		//array to hold a randomly chosen alerted sound
		private var arySfxAlerted:Array;
		// variable to hold sprite sheet object
		private var sprZombie:Spritemap = new Spritemap(ZOMBIES, 58, 90);
		// timer for when to start and end idle movement
		private var startMove:Number;
		private var endMove:Number;
		private var rndMovement:Number;
		// variables for how much to move left or right
		private var moveLeft:Number;
		private var moveRight:Number;
		// point variable to hold the velocity
		public var v:Point;
		// variable to hold the x position in the center of their width
		private var playerXMiddle:Number;
		// variable to hold the player object
		public var player:Player;
		// variables to hold if zombie is colliding on the left or right side with an object
		public var isCollideLeft:Boolean;
		public var isCollideRight:Boolean;
		//variables to hold a delay for being hit and attacking
		public var hitDelay:Number;
		public var attackDelay:Number;
		// variable to hold the health of the zombie
		public var myHealth:Number;
		//variable to hold the map background
		public var myBackground:Image;
		//variable to hold the original position when the zombie was added to the Stage
		public var origPosX:Number;
		// array to hold all the zombie entities
		public var aryCZombies:Array;
		// variable to hold the increase in health
		public var healthInc:Number;
		// variable to check if zommbie is currently attacking or not and if it is being attacked
		public var isAttacking:Boolean;
		public var attacked:Boolean;
		//variable to hold the game world object
		public var gameWorld:GameWorld;
		// variable to hold if the zombie is being hit or not
		public var isHit:Boolean = false;
		// variable to hold random speed increase
		protected var rndSpeed:int = 0;
		
		//------------------------------------------------CONSTRUCTOR
		
		public function Zombie(x:Number,y:Number,myType:String,myPlayer:Player,map:Image,gWorld:GameWorld) 
		{
			// get the passed in game world
			gameWorld = gWorld;
			// init the alerted sounds array  
			arySfxAlerted = new Array();
			arySfxAlerted[0] = new Sfx(ALERTED_ONE_SND);
			arySfxAlerted[1] = new Sfx(ALERTED_TWO_SND);
			arySfxAlerted[2] = new Sfx(ALERTED_THREE_SND);
			// get the original position
			origPosX = x;
			// get the passed in map
			myBackground = map;
			//set the health
			myHealth = TOTAL_HEALTH;
			//getClass the passed in player
			player = myPlayer;
			// set the type of the zombie
			this.type = myType;
			// init all of the animations
			//construct an array to pass for the frames in the animation
			var aryAnimation:Array = new Array();
			for (var i:int= 0; i < 80; i++) 
			{
				aryAnimation[i] = i;
			}
			// init the idle, walk raise arms and death animations
			sprZombie.add("idle", [100], 60, false);
			sprZombie.add("walk", aryAnimation, 60, true);
			sprZombie.add("raiseArms", [103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131], 24, false);
			sprZombie.add("death", [172, 173, 174, 175, 176, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199], 100, false);
			//construct an array to pass for the frames in the animation
			var aryAnimation1:Array = new Array();
			var ex:int = 0;
			for (var g:int= 165; g < 173; g++) 
			{
				aryAnimation1[ex] = g;
				ex++;
			}
			// init the attack animation
			sprZombie.add("attack", aryAnimation1, 100, false);
			// set the posittion 
			super(x, y);
			// create teh hitbox
			setHitbox(40, 90);
			// init the movement variables and timers
			isAttacking = false;
			startMove = 0;
			endMove = 0;
			rndMovement = Math.floor(Math.random() * MAX_MOVE_TIME);
			v = new Point();
			v.x = 0;
			moveLeft = 0;
			moveRight = 0;
			rndSpeed = SPEED + Math.floor(Math.random() * 100);
			v.x = rndSpeed;
			// set the delays for being hit and attacking
			hitDelay = HIT_DELAY;
			attackDelay = ATTACK_DELAY;
			// set the graphic 
			graphic = sprZombie;
			// init misc variables
			aryCZombies = new Array();
			healthInc = 1;
			attacked = false;
			// increase the volumn of the death sounds
			sfxDeath.volume = 8;
			// set the zombie to invisibile by default
			this.visible = false;
		}
		//------------------------------------------------GAME LOOP
		override public function update():void {
			// check which side the player is on and face the zombie in that direction
			if (x > player.centerX) {
				sprZombie.flipped = true;
			}else {
				sprZombie.flipped = false;
			}
			// reset the color
			sprZombie.color = 0xffffff;
			// check if health is depleted
			if (myHealth <= 0) {
				//reset some properties upon death
				isAttacking = false;
				attacked = false;
				myHealth = -1;
				isHit = false;
				// play the death animation and sounds
				sfxDeath.play();
				sprZombie.play("death");
				// when the animation is complete
				if (sprZombie.complete) {
					trace("rem");
					// create a floating score object andd add it above the zombies head
					var myScore:FloatingScore = new FloatingScore(centerX, this.y); 
					gameWorld.add(myScore);
					// randomly choose to create a health pack or not set it at the zombies feet
					if ((Math.floor(Math.random()*100)  <= 25)&& (player.myHealth < 200)) {
						var myHealthPack:HealthPack = new HealthPack(centerX, this.y + this.height); 
						myHealthPack.y = this.y + (this.height - myHealthPack.height);
						gameWorld.add(myHealthPack);
					}
					// add more time to the clock, if the waves are over 4 decrease how much time is added
					var timeIncrease:Number = 5;
					if (gameWorld.waveNum > 3) timeIncrease = 2;
					gameWorld.survivalTime += timeIncrease;
					// increase the score
					gameWorld.score += 100;
					//remove the zombie from the world
					world.remove(this);
				}				
			}
			// do not allow any thing else to happen when the zombie is dead
			// this is to prevent anything else from trying to take place 
			if (!(myHealth <= 0)) {
				//increase the hit delay
				hitDelay += FP.elapsed;
				//check for distance away from player
				playerXMiddle = player.x + (player.width / 2);
				var distanceFromMe:Number = Math.abs(playerXMiddle - (x + width / 2));
				// check if the zombie is not currently attacking or dying
				if (sprZombie.currentAnim != "death" || sprZombie.currentAnim != "attack") {
					// check if the zombie is close enough to the player
					if (distanceFromMe < 300) {
						// check if currently attacking
						if (isAttacking) {
							attacked = true;
						}
						// if the zombie attacked
						if (attacked) {
							// play the attack anim and sound
							sfxAttack.play();
							sprZombie.play("attack");
							// when the animation is complete kill the boolean
							if (sprZombie.complete) {
								attacked = false;
							}
						}else { // if the zombie did not attack
							// if he is idle
							if (sprZombie.currentAnim == "idle") {
								// randomly select an alerted sound
								var rndSound:int = Math.floor(Math.random() * 3);
								//play the alerted sounds and raise arms
								arySfxAlerted[rndSound].play();
								sprZombie.play("raiseArms");
							} 
							// if the zombie is currently walking or if raise arms or attack, allow the zombie to move to attack
							if ((sprZombie.currentAnim == "walk") ||
								(sprZombie.complete && sprZombie.currentAnim == "raiseArms") ||
								(sprZombie.currentAnim == "attack")) {
									
								if(distanceFromMe > 75 || player.touchingGround)attackMovement();
							}
						}
						
					}else {
						// other than all that just play the idle anim and movement
						sprZombie.play("idle");
						
						//if(sprZombie.currentAnim != "walk")sprZombie.play("idle");
						if (distanceFromMe > 600) idleMovement();
						
						
					}				
				}
				// reset the attacking boolean
				isAttacking = false;
				// reassign the speed
				v.x = rndSpeed;
				
				//----------------------------------collision detection
				//crate
				var c:Crate = collide("crate", x, y) as Crate;
				isCollideLeft = false;
				isCollideRight = false;
				// currently colliding with the crate
				if (c != null) {
					// check which side the zombie is colliding with and assign the variables 
					if ((c.x <= x + width) && (c.x > x)) {
						isCollideLeft = true;
					}else if ((c.x + c.width >= x)) {
						isCollideRight = true;
					}
				}
				// colliding with player
				var p:Player = collide("player", x, y) as Player;
				
				// ----------attacking
				attackDelay += FP.elapsed;
				if (p) {
					// if the zombie is touching the player and the delay has been long enough attack
					if (attackDelay > ATTACK_DELAY) {
						isAttacking = true;
						attackDelay = 0;
					}
					// stop the zombie from moving
					v.x = 0;
				}
				
				//edge of map collision
				if ((x + width >= myBackground.x +myBackground.width -50)) {
					isCollideLeft = true;
				}
				if ((x <= myBackground.x + 75)) {
					isCollideRight = true;
				}
				// check if the zombie was hit by the player
				if (isHit) {
					// randomly choose an amount to deprecate health with, there could potentially be a kill shot
					myHealth -= (HEALTH_DEP + Math.floor(Math.random() * 125));
					// flash the zombie red
					sprZombie.color = 0xff0000;
					// reset variables
					hitDelay = 0;
					isHit = false;
					// knock the zombie back
					knockBack(SPEED*4);
				}
			}
			super.update();
		}
		
		//------------------------------------------------PUBLIC METHODS
		// ovveridden method for when the zombie is removed from teh world
		public override function removed():void {
			// reset to original position
			x = origPosX;
			// make him invisible to prevent any collision issues
			this.visible = false;
		}
		// ovveridden method for when the zombie is added to teh world
		public override function added():void {
			// increase how much to depcreate health
			healthInc += 0.2;
			// make visible again
			this.visible = true;
			// reset health
			myHealth = TOTAL_HEALTH * healthInc;
		}
		// function to move zombie to attack
		public function attackMovement():void {
			// check which side the player is on and move in that direction
			// unless colliding with something
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
			// play walk animation
			sprZombie.play("walk");
			
			
		}
		
		// function for idle movement
		public function idleMovement():void{
			//randomly move zombie while in idle state;
			
				startMove += FP.elapsed;
				endMove += FP.elapsed;
			
				// timers to start and end move  are decided randomly
				if (startMove >= rndMovement) {
					rndMovement = Math.floor(Math.random() * MAX_MOVE_TIME);
					startMove = 0;
					endMove = 0;
					// the direction is also random
					if (randomBoolean()) {
						moveRight = Math.floor(Math.random() * 4);
						moveLeft = 0;
					}else {
						moveLeft = Math.floor(Math.random() * 4);
						moveRight = 0;
					}
					
				}
				// after distance and direction are decided move zombie, unless collliding
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
				// play walk anim
				sprZombie.play("walk");
		}
		// function to create a random boolean 
		protected function randomBoolean():Boolean
		{
			return Boolean( Math.round(Math.random()) );
		}
		// function to knock zombie back when struck
		public function knockBack(speed:Number):void {
			
			if (player.x > x) {
				x -= (speed * 3) * FP.elapsed;
			}else {
				x += (speed * 3) * FP.elapsed;  
			}
		}
		
		
	}

}