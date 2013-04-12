package entities 
{
	import net.flashpunk.Entity;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HealthPack extends Entity 
	{
		[Embed(source = '../../assets/healthPack.png')] private const HEALTH_PACK:Class;
		
		private var imgHealthPack:Image;
		private var isAdded:Boolean;
		private var timer:Number;
		
		public function HealthPack(x:Number,y:Number) 
		{
			timer = 0;
			isAdded = false;
			imgHealthPack = new Image(HEALTH_PACK);
			graphic = imgHealthPack;
			setHitbox(imgHealthPack.width,imgHealthPack.height);
			super(x, y);
			type = "health";
		}
		public override function update():void {
			imgHealthPack.alpha = 1;
			if (isAdded) {
				timer += FP.elapsed;
				if (Math.floor(timer % 2) == 0) {
					imgHealthPack.alpha = 0.7;
				}
			}
			if (timer > 10) {
				world.remove(this);
			}
			
			super.update();
		}
		public override function added():void {
			isAdded = true;
		}
		
	}

}