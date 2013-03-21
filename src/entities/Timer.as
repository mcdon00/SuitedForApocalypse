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
	public class Timer extends Entity 
	{
		public var timer:Text;
		public var time:Number;
		
		public function Timer(x:Number,y:Number) 
		{
			time = 0;
			super(x, y);
			timer = new Text("Survival Time: " + time);
			
			timer.size = 20;
			graphic = timer;
		}
		
		
		public  function setTime(myTime:Number):void {
			time = myTime;
			timer.text = "Survival Time: " + time;
		}
	}

}