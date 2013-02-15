package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
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
		
		
		//------------------------------------------------PROPERTIES
		protected var sprPlayerBreathRight:Spritemap = new Spritemap(PLAYER_BREATH_RIGHT, 42, 100);
		protected var sprPlayerBreathLeft:Spritemap = new Spritemap(PLAYER_BREATH_LEFT, 49.45, 89.95);
		protected var sprPlayerWalkRight:Spritemap = new Spritemap(PLAYER_WALK_RIGHT, 45, 89);
		protected var sprPlayerWalkLeft:Spritemap = new Spritemap(PLAYER_WALK_LEFT, 61, 90);
		protected var sprPlayerJumpUpLeft:Spritemap = new Spritemap(PLAYER_JUMP_UPLEFT, 59, 93);
		protected var state:String;
		protected var a:Point;
		protected var v:Point;
		protected var jumpDelay:Number;
		protected var attackDelay:Number;
		
		//-------------------------------------------------CONSTRUCTOR
		public function Player(x:Number,y:Number) 
		{
			super(x, y);
			type = "player";
			jumpDelay = 0;
			attackDelay = ATTACK_DELAY;
			var aryAnimation:Array = new Array();
				for (i= 0; i < 15; i++) 
			{
				aryAnimation[i] = i;
			}
			sprPlayerJumpUpLeft.add("playerJumpUpLeft", aryAnimation, 100, false);
			for (var i:int = 0; i < 59; i++) 
			{
				aryAnimation[i] = i;
			}
			
			sprPlayerBreathRight.add("playerBreathRight", aryAnimation, 60, true);
			sprPlayerBreathLeft.add("playerBreathLeft", aryAnimation, 60, true);
			
			for (i= 0; i < 129; i++) 
			{
				aryAnimation[i] = i;
			}
			
			sprPlayerWalkRight.add("playerWalkRight", aryAnimation, 100, true);
			sprPlayerWalkLeft.add("playerWalkLeft",aryAnimation,100,true);
			
			graphic = sprPlayerBreathRight;
			
			state = IDLE_RIGHT;
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("up", Key.UP, Key.W);
			
			setHitbox(45,90);
			//variables for acceleration and gravity
			a = new Point();
			v = new Point();
			
		}
		//-------------------------------------------------GAME LOOP
		override public function update():void {
			//check for left movement
			attackDelay += FP.elapsed;
			if (state != JUMP_LEFT || state != JUMP_RIGHT ) {
				if (Input.check("left")) {
					state = WALKING_LEFT;
					graphic = sprPlayerWalkLeft;
					sprPlayerWalkLeft.play("playerWalkLeft");
				}else  if(Input.released("left")){
					state = IDLE_LEFT;
				}
				
				//check for right movement
				if (Input.check("right")) {
					state = WALKING_RIGHT;
					graphic = sprPlayerWalkRight;
					sprPlayerWalkRight.play("playerWalkRight");
				}else if(Input.released("right")) {
					state = IDLE_RIGHT;
				}
			}
			//check if colliding with crate
			var c:Crate = collide("crate", x, y) as Crate;
			var z:Zombie = collide(Zombie.TYPE_TSHIRT_ZOMBIE, x, y) as Zombie;
			//check for jumping
			jumpDelay -= FP.elapsed;
			if (!z) {
				if (Input.check("up") && jumpDelay <= 0) jump(c);//TODO have to play animation while in jump state
			}
			
			
			if (state == JUMP_LEFT) {
				graphic = sprPlayerJumpUpLeft;
				sprPlayerJumpUpLeft.play("playerJumpUpLeft");
				if (sprPlayerJumpUpLeft.frameCount >= 14) {
					
				}
			}
			
			//check if idle
			if (state == IDLE_RIGHT) {
				graphic = sprPlayerBreathRight;
				sprPlayerBreathRight.play("playerBreathRight");
			}else if (state == IDLE_LEFT) {
				graphic = sprPlayerBreathLeft;
				sprPlayerBreathLeft.play("playerBreathLeft");
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
				
				//check if touching zombie while on ground
				if (z) {
					if (Input.check(Key.SPACE)) {
						//TODO add attack animation
					}
				}
			}else if (c) {
				//check if touching crate top
				if (c.x < (x + width - 10) && (c.x+c.width > x + 10)  &&(y + this.height > FP.screen.height-PLATFORM_HEIGHT-c.height+2)) {
					v.y = 0;
					y = FP.screen.height - PLATFORM_HEIGHT - height - c.height +1;
				}
			}else if (z) {
				//check if touching zombie top
				if ((z.x < (x + width - 20) && (z.x+z.width > x + 20)  &&(y + this.height > FP.screen.height-PLATFORM_HEIGHT-z.height))) {
					v.y = 0;
					y = FP.screen.height - PLATFORM_HEIGHT - height - z.height;
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
				
			}else {
				if (state == IDLE_LEFT || state == WALKING_LEFT) {
					state = JUMP_LEFT;
					
				}else if (state == IDLE_RIGHT || state == WALKING_RIGHT) {
					state = JUMP_RIGHT;
				}
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