package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	
	/**
	 * ...
	 * @author Nathan
	 */
	public class Lamp extends Entity 
	{
		//-------------------------------------------------CONSTANTS
		// lamp sprite sheet
		[Embed(source = '../../assets/lamp.png')] private const LAMP:Class;
		// max time lamp can wait until flicker
		private const MAX_FLICKER_TIME:int = 50;
		//-------------------------------------------------PROPERTIES
		// variable to hold sprite sheet object
		public var sprLamp:Spritemap = new Spritemap(LAMP, 104.9, 285);
		// variablees for the flicker time and the random number selected to start the flicker
		public var flickerTime:Number;
		public var rndFlicker:Number;
		//-------------------------------------------------CONSTRUCTOR
		public function Lamp(x:Number,y:Number) 
		{
			// set the height of this object to the sprite sheet height and width
			height = sprLamp.height;
			width = sprLamp.width;
			// set the position
			super(x, y);
			// init the flicker animation
			var aryFlickers:Array = new Array();
			for (var i:int = 0; i < 64; i++) 
			{
				aryFlickers[i] = i;
			}
			sprLamp.add("flicker", aryFlickers, 60, false);
			// set the graphic to the sprite
			graphic = sprLamp;
			// init the flicker and and generate a random time to flicker
			flickerTime = 0;
			rndFlicker = Math.floor(Math.random()* MAX_FLICKER_TIME) +5;
		}
		//-------------------------------------------------GAME LOOP
		override public function update():void {
			// increment the flicker time
			flickerTime +=  FP.elapsed;
			// when it reaches the time to flicker start the animation
			if (flickerTime >= rndFlicker) {
				// reset the frame and the flicker time
				sprLamp.setFrame(0);
				flickerTime = 0;
				sprLamp.play("flicker");
				//regenerate the time to flicker
				rndFlicker = Math.floor(Math.random()* MAX_FLICKER_TIME) +5
			}
			super.update();
		}
	}

}