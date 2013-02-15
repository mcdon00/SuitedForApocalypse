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
		[Embed(source = '../../assets/lamp.png')] private const LAMP:Class;
		private const MAX_FLICKER_TIME:int = 100;
		//-------------------------------------------------PROPERTIES
		public var sprLamp:Spritemap = new Spritemap(LAMP,104.9,285);
		
		public var flickerTime:Number;
		public var rndFlicker:Number;
		//-------------------------------------------------CONSTRUCTOR
		public function Lamp(x:Number,y:Number) 
		{
			height = sprLamp.height;
			width = sprLamp.width;
			super(x, y);
			var aryFlickers:Array = new Array();
			for (var i:int = 0; i < 64; i++) 
			{
				aryFlickers[i] = i;
			}
			
			sprLamp.add("flicker",aryFlickers,60,false);
			graphic = sprLamp;
			flickerTime = 0;
			rndFlicker = Math.floor(Math.random()* MAX_FLICKER_TIME) +5;
		}
		//-------------------------------------------------GAME LOOP
		override public function update():void {
			flickerTime +=  FP.elapsed;
			
			if (flickerTime >= rndFlicker) {
				sprLamp.setFrame(0);
				flickerTime = 0;
				sprLamp.play("flicker");
				rndFlicker = Math.floor(Math.random()* MAX_FLICKER_TIME) +5
			}
			super.update();
		}
	}

}