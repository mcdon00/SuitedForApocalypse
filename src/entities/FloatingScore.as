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
		//-------------------------------------------------CONSTANTS
		//-------------------------------------------------PROPERTIES
		// variables for the score text and if the score object was added to the stage
		private var score:Text;
		private var isAdded:Boolean;
		//-------------------------------------------------CONSTRUCTOR
		public function FloatingScore(x:Number,y:Number) 
		{
			// default to not added 
			// init the score text and it's size
			isAdded = false;
			score = new Text("100");
			score.size = 20;
			// set this entity's graphic to the score text
			graphic = score;
			// set it's psotion
			super(x,y);
		}
		//-------------------------------------------------GAME LOOP
		public override function update():void {
			//when this score has been added immediately start moving it upwards
			if (isAdded) y -= 125 * FP.elapsed;
			// as it moves it slowely disapears
			score.alpha -= 0.02;
			// when it reaches the top of the screen remove it from this world
			if (y <= 0) world.remove(this);
			super.update();
		}
		//-------------------------------------------------METHODS
		//function to set the added variable to true
		public override function added():void {
			isAdded = true;
		}
	}

}