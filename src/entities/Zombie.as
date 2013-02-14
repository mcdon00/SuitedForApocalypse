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
		private const MAX_MOVE_TIME:int = 150;
		
		//------------------------------------------------PROPERTIES
		protected var sprZombiePlaceHolder:Spritemap = new Spritemap(ZOMBIE_PLACEHOLDER, 36, 93);
		protected var moveTime:Number;
		protected var rndMovement:Number;
		protected var moveLeft:Number;
		protected var moveRight:Number;
		
		protected var v:Point;
		
		//------------------------------------------------CONSTRUCTOR
		
		public function Zombie(x:Number,y:Number,myType:String) 
		{
			
			
			this.type = myType;
			sprZombiePlaceHolder.add("zombiePlaceHolder", [1], 100, false);
			super(x, y, sprZombiePlaceHolder);
			setHitbox(50, 90);
			
			moveTime = 0;
			rndMovement = Math.floor(Math.random() * MAX_MOVE_TIME);
			v = new Point();
			v.x = 0;
			moveLeft = 0;
			moveRight = 0;
			v.x = 100;
		}
		//------------------------------------------------GAME LOOP
		override public function update():void {
			sprZombiePlaceHolder.play();
			
			
			//TODO create conditions for movement
			idleMovement();
			
			super.update();
		}
		
		//------------------------------------------------PUBLIC METHODS
		
		public function idleMovement():void{
			//randomly move zombie while in idle state;
			moveTime += FP.elapsed;
			rndMovement = Math.floor(Math.random() * MAX_MOVE_TIME);
			
			if (moveTime >= rndMovement) {
				
				moveTime = 0;

				
				
				if (randomBoolean()) {
					moveRight = Math.floor(Math.random() * 100);
					moveRight = x + moveRight;
					//trace(moveRight + " MOVERIGHT");
					moveLeft = 0;
				}else {
					moveLeft = Math.floor(Math.random() * 100);
					moveLeft = x - moveLeft;
					//trace(moveLeft + " MOVELEFT");
					moveRight = 0;
				}
				
			}
			
			
			
			//trace(distanceToMove + "Distance to move");
			
			
			//if (!(x > distanceToMove) || !(x < distanceToMove)) {
				
			//}
			
			if (moveRight != 0) {
				if (!(x >= moveRight)) {
					x += v.x * FP.elapsed;
				}else {
					x = moveRight;
					moveLeft = 0;
				}
				//trace(x + " POS X MOVERIGHT" + moveRight);
			}else if(moveLeft != 0) {
				if (!(x <= moveLeft)) {
					x -= v.x * FP.elapsed;
					trace("YES");
				}else {
					x = moveLeft;
					moveRight = 0;
					trace("NO");
				}
				//trace(x + " POS X MOVELEFT" + moveLeft);
			}
		}
		
		protected function randomBoolean():Boolean
		{
			return Boolean( Math.round(Math.random()) );
		}
		 
		
		
	}

}