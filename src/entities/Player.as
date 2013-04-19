package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import net.flashpunk.tweens.sound.SfxFader;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import flash.display.BitmapData;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author nathan
	 */
	
	public class Player extends Entity 
	{
		
		//------------------------------------------------CONSTANTS
		// sprite sheet and images for player and gun fire
		[Embed(source = '../../assets/playerRight.png')] private const PLAYER:Class;
		[Embed(source = '../../assets/gunFire.png')] public const GUN_FIRE:Class;
		// shot gun sound for gun fire
		[Embed(source = '../../assets/sound/shotGun.mp3')] public const SHOTGUN_FIRE:Class;
		// variables to test if player is facing left or right
		public var FACING_RIGHT:Boolean = true;
		public var FACING_LEFT:Boolean = false;
		//constants for the current state of the player, walking, jumping, etc
		private const IDLE_LEFT:String = "iLeft";
		private const IDLE_RIGHT:String = "iRight";
		private const WALKING_RIGHT:String = "wRight";
		private const WALKING_LEFT:String = "wLeft";
		private const JUMP_RIGHT:String = "jRight";
		private const JUMP_LEFT:String = "jLeft";
		// constants for how high player jumps and his jump delay
		private const JUMP:int = 400;
		private const JUMP_DELAY:Number = 1.5;
		// constants for the gravity that affects the player
		private const GRAVITY:Number = 9.8;
		// constant for the height of the platform entities walk on
		private const PLATFORM_HEIGHT:Number = 136;
		// constant for the delay on player attacks
		private const ATTACK_DELAY:Number = .5;
		// constant the the player's health
		public static const HEALTH:Number = 200;
		
		
		//------------------------------------------------PROPERTIES
		// sprite sheet object for player
		public var sprPlayer:Spritemap = new Spritemap(PLAYER, 70, 96);
		//image object for gun fire
		public var imgGunFire:Image = new Image(GUN_FIRE);
		//sound for gunfire
		public var sfxShoot:Sfx = new Sfx(SHOTGUN_FIRE);
		// variable to hold current state of player
		public var state:String;
		// point object to hold acceleration
		protected var a:Point;
		// point object to hold velocity
		protected var v:Point;
		// variabel to hold jump delay time and attack time
		protected var jumpDelay:Number;
		protected var attackDelay:Number;
		// variable to hold player current health
		public var myHealth:Number = HEALTH;
		// array for amount of zombies on stage
		public var aryZombies:Array;
		// boolean variable to test if player is touch ground
		public var touchingGround:Boolean;
		// variable to hold game world object
		public var gameWorld:GameWorld;
		
		
		//-------------------------------------------------CONSTRUCTOR
		public function Player(x:Number,y:Number,gWorld:GameWorld) 
		{
			// set the position
			super(x, y);
			// set the type 
			type = "player";
			// init the delay variables
			jumpDelay = 0;
			attackDelay = ATTACK_DELAY;
			// get the gameworld object
			gameWorld = gWorld;
			// construct and init the idle animation
			var aryAnimation:Array = new Array();
			var ex:int = 0;
			
			for (var i:int= 0; i < 39; i++) 
			{
				aryAnimation[ex] = i;
				ex++;
			}
			sprPlayer.add("idle", aryAnimation, 24, true);
			// construct and init the walk animation
			ex = 0;
			var aryAnimation1:Array = new Array();
			for (i= 39; i < 86; i++) 
			{
				aryAnimation1[ex] = i;
				ex++;
			}
			sprPlayer.add("walk", aryAnimation1, 60, true);
			// construct and init the attack,jump death animation
			sprPlayer.add("attack", [116], 60, false);
			sprPlayer.add("jump", [85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 108, 109, 110, 111], 40, false);
			sprPlayer.add("death", [124, 125, 126, 127, 128, 129, 130, 131, 132], 20, false);
			// set the state to idle first
			state = IDLE_RIGHT;
			//define the controls
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("up", Key.UP, Key.W);
			//set the hitbox variables
			setHitbox(50, 90);
			// set the fire colume
			sfxShoot.volume = 0.7;
			//variables for acceleration and gravity
			a = new Point();
			v = new Point();
			//set the graphic to the sprite sheet
			graphic = sprPlayer;
			// init the touching ground boolean
			touchingGround = true;
			// set the gun fire image to the right location
			imgGunFire.x = width+5;
			imgGunFire.y = (height / 2) + 10;
			addGraphic(imgGunFire);
			// make it invisible and reduce the alpha 
			imgGunFire.visible = false;
			imgGunFire.alpha = 0.8;
		}
		//-------------------------------------------------GAME LOOP
		override public function update():void {
			//check if the spprite sheet is flipped or not and set the direction faced accordingly
			if (sprPlayer.flipped) {
				FACING_RIGHT = false;
				FACING_LEFT = true;
			}else {
				FACING_RIGHT = true;
				FACING_LEFT = false;
			}
			// reset the sprite sheet direction
			sprPlayer.flipped = false;
			// increment the attack delay and reset the gun fire to in visible
			attackDelay += FP.elapsed;
			imgGunFire.visible = false;
			// check which direction player is facing and change the side the gun fire is positioned 
			if (FACING_LEFT) {
				imgGunFire.x = 5;
			}else {
				imgGunFire.x = width+5;
			}
			// do not allow anything else to happen in the game loop if player is dead
			if (!(myHealth <= 0) || gameWorld.gameover) {
				//check if Player is not jumping or dead
				if (state != JUMP_LEFT && state != JUMP_RIGHT && state != "dead") {
					//check if moving right
					if (Input.check("right") ) {
						// if the left key is pressed while moving right allow player to look left
						// set set the states and sprite sheet direction, start the walk anim
						if (Input.check(Key.LEFT) && Input.check(Key.D)) {
							FACING_LEFT = true;
							FACING_RIGHT = false;
							state = WALKING_LEFT;
							sprPlayer.flipped = true;
							sprPlayer.play("walk")
						}else {
							sprPlayer.flipped = false;
							FACING_LEFT = false;
							FACING_RIGHT = true;
							state = WALKING_RIGHT;
							sprPlayer.play("walk")
						}
						// check if the direction buttons are released if aset the state to idle 
					}else if (Input.check("left")) {
						// same as right movement but reversed
						if (Input.check(Key.RIGHT) && Input.check(Key.A)) {	
							FACING_LEFT = false;
							FACING_RIGHT = true;
							state = WALKING_RIGHT;
							sprPlayer.flipped = false;
							sprPlayer.play("walk")
						}else {
							FACING_LEFT = true;
							FACING_RIGHT = false;
							state = WALKING_LEFT;
							sprPlayer.flipped = true;
							sprPlayer.play("walk")
						}
					}else if(Input.released("right")) {
						state = IDLE_RIGHT;
					}else if(Input.released("left")){
						state = IDLE_LEFT;
					}
				}
				
				//-----------------------collision detection
				//colliding with healthPacks
				//get the health pack player is colliding with
				var h:HealthPack = collide("health", x, y) as HealthPack;
				if (h) {// if colliding
					// remove health pack from stage
					world.remove(h);
					// if player health is less than 200
					if (myHealth < 200) {
						// increment health
						myHealth += 10;
						// if after incrementing the health it is greater than 200 remove the difference
						if (myHealth > 200) {
							var difference:Number = myHealth - 200;
							myHealth -= difference;
						}
					}
					// update the health bar graphic 
					gameWorld.healthBar.updateHealthBar(myHealth);
				}
				
				//check if colliding with crate
				var c:Crate = collide("crate", x, y) as Crate;
				var aryCCrates:Array = [];
				collideInto("crate", x, y, aryCCrates);
				// get the zombie player is colliding with
				var z:Zombie = collide(Zombie.TYPE_TSHIRT_ZOMBIE, x, y) as Zombie;
				//check for jumping
				jumpDelay -= FP.elapsed;
				if (!z) {
					// if colliding with zombies 
					if (Input.check("up") && jumpDelay <= 0) jump(c);
				}
				// check if player is jumping
				if (state == JUMP_RIGHT) {
					sprPlayer.play("jump");
				}else if (state == JUMP_LEFT ) {
					sprPlayer.flipped = true;
					sprPlayer.play("jump");
				}
				
				//check if idle
				if (state != JUMP_RIGHT && state != JUMP_LEFT) {
					if (state == IDLE_RIGHT) {
						sprPlayer.play("idle");					
					}else if (state == IDLE_LEFT) {
						sprPlayer.flipped = true;
						sprPlayer.play("idle");
					}
				}
				
				//check if zombies are in range
				var zombsLeft:Array = [];
				var zombsRight:Array = [];
				//loop through each of the zombies in the map
				for (var j:int = 0; j < aryZombies.length ; j++) 
				{	// get the distance from each bewtween him and the player
					var distanceFromMe:Number = Math.abs(aryZombies[j].centerX - (this.centerX));
						if (distanceFromMe < 275) {
							// check if player is less than 275 px from any zombies
							// put all of the zombies withing range on the left and right side into two arrays
							if ((aryZombies[j].centerX <= this.centerX) && (aryZombies[j].visible)) {
								zombsLeft.push(aryZombies[j]);
							}
							if ((aryZombies[j].centerX >= this.centerX) && (aryZombies[j].visible)) {
								zombsRight.push(aryZombies[j]);
							}
						}
				}
				// for both sides check which zombie is closest
				var zombieToHitRight:Zombie = zombsRight[0];
				for (var k:int = 1; k < zombsRight.length; k++) 
				{
					if (zombieToHitRight.centerX > zombsRight[k].centerX) zombieToHitRight = zombsRight[k];
				}
				
				// of the zombies that are within range on the left side find the closest
				var zombieToHitLeft:Zombie = zombsLeft[0];
				for (var k:int = 1; k < zombsLeft.length; k++) 
				{
					if (zombieToHitLeft.centerX < zombsLeft[k].centerX) zombieToHitLeft = zombsLeft[k];
				}
				
				//--------------------------------------attacking
				if (Input.pressed(Key.SPACE)) {
					// do not allow gun to fire if sound is still playing
					if (!(sfxShoot.playing ) || sfxShoot.position >= 1) {
						// make sure there is a zombie to hit
						if (zombieToHitRight != null) {
							// make sure you can't fire while above zombies
							if (!(centerY <= zombieToHitRight.y)) {
								if (this.FACING_RIGHT  && !zombieToHitRight.isCollideRight) {
									zombieToHitRight.isHit = true;
								}
							}
						}
						// same as above but on the left side
						if (zombieToHitLeft != null) {
							if (!(centerY <= zombieToHitLeft.y)) {
								if (this.FACING_LEFT  && !zombieToHitLeft.isCollideLeft) {
									zombieToHitLeft.isHit = true;
								}	
							}
						}
						// play gun fire sound
						sfxShoot.play();
						// show gun fire
						imgGunFire.visible = true;
						
					}
					
				}
				
				//update physics
				a.y = GRAVITY;
				v.y += a.y;
				
				//apply physics
				y += v.y * FP.elapsed;
				
				//collision checks
				//check for touching ground
				if (y + this.height > FP.screen.height-PLATFORM_HEIGHT) {
					v.y = 0;
					y = FP.screen.height - PLATFORM_HEIGHT - height;
					touchingGround = true;
					
					if (state == JUMP_RIGHT) {
						state = IDLE_RIGHT;
					}else if (state == JUMP_LEFT){
						state = IDLE_LEFT;
					}
				}else if (c) {
				}else {
					touchingGround = false;
					if (state == WALKING_RIGHT || state == IDLE_RIGHT) {
						state = JUMP_RIGHT;
					}else if (state == WALKING_LEFT || state == IDLE_LEFT){
						state = JUMP_LEFT;
					}else if (Input.check("left")) {
						state = JUMP_LEFT;
					}else if (Input.check("right")) {
						state = JUMP_RIGHT;
					}
				}
				
				//check for obstacle collision
				for (var i:int = 0; i < aryCCrates.length; i++) 
				{
					//check if touching crate top
					if (!(y + this.height > FP.screen.height-PLATFORM_HEIGHT)) {
						if (aryCCrates[i].x < (x + width - 10) && (aryCCrates[i].x+aryCCrates[i].width > x + 10)  &&(y + this.height > FP.screen.height-PLATFORM_HEIGHT-aryCCrates[i].height+2)) {
							v.y = 0;
							y = FP.screen.height - PLATFORM_HEIGHT - height - aryCCrates[i].height +1;
							touchingGround = true;
							if (state == JUMP_RIGHT) {
								state = IDLE_RIGHT;
							}else if (state == JUMP_LEFT){
								state = IDLE_LEFT;
							}
						}
					}
				}
			}
			super.update();
		}
		//-------------------------------------------------METHODS
		// function to make the player jump
		protected function jump(c:Entity):void {
			// allow jump if on top of obstacles
			if (c != null) {
				if (c.x +10 <= x + width && c.x+c.width -10 >= x) {				
					if ((y + height >= FP.screen.height - PLATFORM_HEIGHT - c.height-5)) {
						v.y = -JUMP;
						jumpDelay = +JUMP_DELAY;
					}
				}
			}
			// allow jump if on ground
			if ((y + height >= FP.screen.height - PLATFORM_HEIGHT)) {
				v.y = -JUMP;
				jumpDelay = JUMP_DELAY;	
			}
		}
		// function to set the global array of zombies
		public function setZombies(myZombies:Array):void {
			aryZombies = myZombies;
		}
	}

}