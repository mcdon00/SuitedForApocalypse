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
	 * @author nathan
	 */
	
	public class Player extends Entity 
	{
		
		//------------------------------------------------CONSTANTS
		[Embed(source = '../../assets/playerBreathRight.png')] private const PLAYER_BREATH_RIGHT:Class;
		[Embed(source = '../../assets/playerBreathLeft.png')] private const PLAYER_BREATH_LEFT:Class;
		[Embed(source = '../../assets/playerWalkRight.png')] private const PLAYER_WALK_RIGHT:Class;
		[Embed(source = '../../assets/playerWalkLeft.png')] private const PLAYER_WALK_LEFT:Class;
		[Embed(source = '../../assets/playerWalkLeft.png')] private const PLAYER_JUMP_UPLEFT:Class;
		
		private const IDLE_LEFT:String = "iLeft";
		private const IDLE_RIGHT:String = "iRight";
		private const WALKING_RIGHT:String = "wRight";
		private const WALKING_LEFT:String = "wLeft";
		private const JUMP_RIGHT:String = "jRight";
		private const JUMP_LEFT:String = "jLeft";
		
		private const JUMP:int = 300;
		private const GRAVITY:Number = 9.8;
		private const PLATFORM_HEIGHT:Number = 136;
		
		
		//------------------------------------------------PROPERTIES
		protected var sprPlayerBreathRight:Spritemap = new Spritemap(PLAYER_BREATH_RIGHT, 42, 100);
		protected var sprPlayerBreathLeft:Spritemap = new Spritemap(PLAYER_BREATH_LEFT, 49.45, 89.95);
		protected var sprPlayerWalkRight:Spritemap = new Spritemap(PLAYER_WALK_RIGHT, 45, 89);
		protected var sprPlayerWalkLeft:Spritemap = new Spritemap(PLAYER_WALK_LEFT, 61, 90);
		protected var sprPlayerJumpUpLeft:Spritemap = new Spritemap(PLAYER_JUMP_UPLEFT, 68, 105);
		protected var state:String;
		protected var a:Point;
		protected var v:Point;
		//-------------------------------------------------CONSTRUCTOR
		public function Player(x:Number,y:Number) 
		{
			super(x,y);
			var aryAnimation:Array = new Array();
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
			
			sprPlayerWalkRight.add("playerWalkRight", aryAnimation, 80, true);
			sprPlayerWalkLeft.add("playerWalkLeft",aryAnimation,80,true);
			graphic = sprPlayerBreathRight;
			
			state = IDLE_RIGHT;
			
			for (i= 0; i < 23; i++) 
			{
				aryAnimation[i] = i;
			}
			sprPlayerWalkLeft.add("playerJumpUpLeft", aryAnimation, 60, true);
			
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("up", Key.SPACE, Key.W);
			
			setHitbox(50,90);
			//variables for acceleration and gravity
			a = new Point();
			v = new Point();
			
		}
		//-------------------------------------------------GAME LOOP
		override public function update():void {
			//check for left movement
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
			//check for jumping
			if (Input.check("up") ) jump();//TODO have to play animation while in jump state
			
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
			if (y + this.height > FP.screen.height-PLATFORM_HEIGHT) {
				v.y = 0;
				y = FP.screen.height-PLATFORM_HEIGHT - height;
			}
			super.update();
		}
		
		
		protected function jump():void {
			if ((y + height >= FP.screen.height-PLATFORM_HEIGHT)) {
				v.y = -JUMP;
				if (state == IDLE_LEFT || state == WALKING_LEFT) {
					state = JUMP_LEFT;
				}else if (state == IDLE_RIGHT || state == WALKING_RIGHT) {
					state = JUMP_RIGHT;
				}
			}else{
				//TODO still have to reset back to idle left or right when you land
			}
		}
	}

}