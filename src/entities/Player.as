package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
		import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author nathan
	 */
	
	public class Player extends Entity 
	{
		
		//------------------------------------------------CONSTANTS
		[Embed(source = '../../assets/playerBreathRight.png')] private const PLAYER_BREATH_RIGHT:Class;
		[Embed(source = '../../assets/playerBreathLeft.png')] private const PLAYER_BREATH_LEFT:Class;
		[Embed(source = '../../assets/playerWalkRight.png')] private const PLAYER_WALK_RIGHT:Class;
		[Embed(source = '../../assets/playerWalkLeft.png')] private const PLAYER_WALK_LEFT:Class;
		[Embed(source = '../../assets/playerJumpUpLeft.png')] private const PLAYER_JUMP_UPLEFT:Class;
		[Embed(source = '../../assets/playerRight.png')] private const PLAYER:Class;
		
		public var FACING_RIGHT:Boolean = true;
		public var FACING_LEFT:Boolean = false;
		
		private const IDLE_LEFT:String = "iLeft";
		private const IDLE_RIGHT:String = "iRight";
		private const WALKING_RIGHT:String = "wRight";
		private const WALKING_LEFT:String = "wLeft";
		private const JUMP_RIGHT:String = "jRight";
		private const JUMP_LEFT:String = "jLeft";
		
		private const JUMP:int = 350;
		private const JUMP_DELAY:Number = 1.3;
		
		private const GRAVITY:Number = 9.8;
		private const PLATFORM_HEIGHT:Number = 136;
		
		private const ATTACK_DELAY:Number = .5;
		public static const HEALTH:Number = 200;
		
		
		//------------------------------------------------PROPERTIES
		protected var sprPlayerBreathRight:Spritemap = new Spritemap(PLAYER_BREATH_RIGHT, 42, 100);
		protected var sprPlayerBreathLeft:Spritemap = new Spritemap(PLAYER_BREATH_LEFT, 49.45, 89.95);
		protected var sprPlayerWalkRight:Spritemap = new Spritemap(PLAYER_WALK_RIGHT, 45, 89);
		protected var sprPlayerWalkLeft:Spritemap = new Spritemap(PLAYER_WALK_LEFT, 61, 90);
		protected var sprPlayerJumpUpLeft:Spritemap = new Spritemap(PLAYER_JUMP_UPLEFT, 59, 93);
		public var sprPlayer:Spritemap = new Spritemap(PLAYER, 70, 96);
		public var state:String;
		protected var a:Point;
		protected var v:Point;
		protected var jumpDelay:Number;
		protected var attackDelay:Number;
		
		public var myHealth:Number = HEALTH;
		
		private var prevAnimIndex:int = -1;
		private var onCrate;
		
		
		//-------------------------------------------------CONSTRUCTOR
		public function Player(x:Number,y:Number) 
		{
			super(x, y);
			type = "player";
			jumpDelay = 0;
			attackDelay = ATTACK_DELAY;
			
			var aryAnimation:Array = new Array();
			var ex:int = 0;
			//-------------------------------new
			for (var i:int= 0; i < 39; i++) 
			{
				aryAnimation[ex] = i;
				ex++;
			}
			sprPlayer.add("idle", aryAnimation, 24, true);
			ex = 0;
			var aryAnimation1:Array = new Array();
			for (i= 39; i < 86; i++) 
			{
				aryAnimation1[ex] = i;
				ex++;
			}
			
			sprPlayer.add("walk", aryAnimation1, 60, true);
			//-------------------------------/new
			
			sprPlayer.add("attack", [116], 60, false);
			sprPlayer.add("jump", [85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 108, 109, 110, 111], 40, false);
			sprPlayer.add("death", [124, 125, 126, 127, 128, 129, 130, 131, 132], 20, false);
			
			state = IDLE_RIGHT;
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("up", Key.UP, Key.W);
			
			setHitbox(60, 90);
			
			//variables for acceleration and gravity
			a = new Point();
			v = new Point();
			
			onCrate = false;
			graphic = sprPlayer;
		}
		//-------------------------------------------------GAME LOOP
		override public function update():void {
			sprPlayer.flipped = false;
			//check for left movement
			attackDelay += FP.elapsed;
			if (state != JUMP_LEFT && state != JUMP_RIGHT && state != "dead") {
				if (Input.check("left")) {
					
					FACING_LEFT = true;
					FACING_RIGHT = false;
					state = WALKING_LEFT;
					sprPlayer.flipped = true;
					
					//trace(prevAnimIndex);
					//if (prevAnimIndex >= 0) {
						//sprPlayer.play("walk");
						//sprPlayer.setAnimFrame("walk", prevAnimIndex);
						//
						//sprPlayer.play("walk");
						//trace(sprPlayer.currentAnim);
						//trace(sprPlayer.frame+"before");
						//sprPlayer.frame = prevAnimIndex;
						//trace(sprPlayer.frame+"after");
						//prevAnimIndex = -1;
					//}else {
						//
					//}
					
					sprPlayer.play("walk");
					
				}else if(Input.released("left")){
					state = IDLE_LEFT;
				}
				
				//check for right movement
				if (Input.check("right")) {
					FACING_LEFT = false;
					FACING_RIGHT = true;
					state = WALKING_RIGHT;
					sprPlayer.play("walk");
				}else if(Input.released("right")) {
					state = IDLE_RIGHT;
				}
			}
			
			//check if colliding with crate
			var c:Crate = collide("crate", x, y) as Crate;
			var aryCCrates:Array = [];
			collideInto("crate", x, y, aryCCrates);
			var z:Zombie = collide(Zombie.TYPE_TSHIRT_ZOMBIE, x, y) as Zombie;
			//check for jumping
			jumpDelay -= FP.elapsed;
			if (!z) {
				if (Input.check("up") && jumpDelay <= 0) jump(c);
			}
			
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
			
			if (Input.pressed(Key.SPACE)) {
				prevAnimIndex = sprPlayer.index;
				sprPlayer.play("attack");
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
				
				if (state == JUMP_RIGHT) {
					state = IDLE_RIGHT;
				}else if (state == JUMP_LEFT){
					state = IDLE_LEFT;
				}
				
			//}else if (z) {
				//check if touching zombie top
				//if ((z.x < (x + width - 20) && (z.x+z.width > x + 20)  &&(y + this.height > FP.screen.height-PLATFORM_HEIGHT-z.height))) {
					//v.y = 0;
					//y = FP.screen.height - PLATFORM_HEIGHT - height - z.height;
					//if (state == JUMP_RIGHT) {
						//state = IDLE_RIGHT;
					//}else if (state == JUMP_LEFT){
						//state = IDLE_LEFT;
					//}
				//}
			}else {
				//TODO this condition is overriding idle when touching crate top, making it so walk anim doesn't play
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
						onCrate = true;
						if (state == JUMP_RIGHT) {
							state = IDLE_RIGHT;
						}else if (state == JUMP_LEFT){
							state = IDLE_LEFT;
						}
					}else {
						onCrate = false;
					}
				}
			}
			
			super.update();
		}
		//-------------------------------------------------METHODS
	
		protected function jump(c:Entity):void {
			if (c != null) {
				if (c.x +10 <= x + width && c.x+c.width -10 >= x) {				
					if ((y + height >= FP.screen.height - PLATFORM_HEIGHT - c.height-5)) {
						v.y = -JUMP;
						jumpDelay = +JUMP_DELAY;
					}
				}
			}
			
			if ((y + height >= FP.screen.height - PLATFORM_HEIGHT)) {
				v.y = -JUMP;
				jumpDelay = JUMP_DELAY;	
			}
			
			
		}

		//public function knockBack():void {
			//v.x = SPEED;
			//sprZombiePlaceHolder.color = 0xff0000;
			//if (player.x > x) {
				//x -= (v.x * 16) * FP.elapsed;  
			//}else {
				//x += (v.x * 16) * FP.elapsed;  
			//}
			//
		//}
		
	}

}