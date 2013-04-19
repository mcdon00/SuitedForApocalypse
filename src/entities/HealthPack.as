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
		//-------------------------------------------------CONSTANTS
		// health pack image
		[Embed(source = '../../assets/healthPack.png')] private const HEALTH_PACK:Class;
		//-------------------------------------------------PROPERTIES
		//variable to hold health pack image object
		private var imgHealthPack:Image;
		// variable for if the entitiy has been added to the stage
		private var isAdded:Boolean;
		// variable for the timer
		private var timer:Number;
		//-------------------------------------------------CONSTRUCTOR
		public function HealthPack(x:Number,y:Number) 
		{
			// init timer added and image variables
			timer = 0;
			isAdded = false;
			imgHealthPack = new Image(HEALTH_PACK);
			// set the graphic to the health pack image
			graphic = imgHealthPack;
			// set the hit box
			setHitbox(imgHealthPack.width, imgHealthPack.height);
			//set the position
			super(x, y);
			// set the type
			type = "health";
		}
		//-------------------------------------------------GAME LOOP
		public override function update():void {
			// reset the alpha on the image
			imgHealthPack.alpha = 1;
			// check if it has been added to the stage
			if (isAdded) {
				// start the timer 
				timer += FP.elapsed;
				// change the alpha intermittently
				if (Math.floor(timer % 2) == 0) {
					imgHealthPack.alpha = 0.7;
				}
			}
			// if the timer is greater than 10 seconds remove the health path from the world
			if (timer > 10) {
				world.remove(this);
			}
			
			super.update();
		}
		//-------------------------------------------------METHODS
		// function to set the added bool
		public override function added():void {
			isAdded = true;
		}
		
	}

}