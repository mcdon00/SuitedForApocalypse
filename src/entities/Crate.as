package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Nathan
	 */
	
	public class Crate extends Entity 
	{
		//------------------------------------------------CONSTANTS
		[Embed(source = '../../assets/crate.png')] private const CRATE:Class;
		//------------------------------------------------PROPERTIES
		public var imgCrate:Image;
		//------------------------------------------------CONSTRUCTOR
		public function Crate(x:Number,y:Number) 
		{
			type = "crate";
			imgCrate = new Image(CRATE);
			super(x, y,imgCrate);
			setHitbox(80,82);
		}
		//------------------------------------------------GAME LOOP
		//------------------------------------------------PUBLIC METHODS
	}

}