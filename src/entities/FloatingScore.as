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
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author ...
	 */
	public class FloatingScore extends Entity 
	{
		private var score:Text;
		private var isAdded:Boolean;
		
		public function FloatingScore(x:Number,y:Number) 
		{
			isAdded = false;
			score = new Text("100");
			score.size = 20;
			graphic = score;
			super(x,y);
		}
		public override function update():void {
			if (isAdded) y -= 125 * FP.elapsed;
			score.alpha -= 0.02;
			if (y <= 0) world.remove(this);
			super.update();
		}
		public override function added():void {
			isAdded = true;
		}
	}

}