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
		
		// crate, grabage can and mailbox images
		[Embed(source = '../../assets/crate.png')] private const CRATE:Class;
		[Embed(source = '../../assets/garbageCan.png')] private const CAN:Class;
		[Embed(source = '../../assets/mailbox.png')] private const MAIL:Class;
		//------------------------------------------------PROPERTIES
		public var imgCrate:Image;
		//------------------------------------------------CONSTRUCTOR
		public function Crate(x:Number,y:Number) 
		{
			var imgArray:Array = new Array();
			// array of images
			imgArray.push(CRATE);
			imgArray.push(CAN);
			imgArray.push(MAIL);
			// select one at random
			Math.floor(Math.random()*3);
			// set the type 
			type = "crate";
			// create a new image object from the image selected rtandomly
			imgCrate = new Image(imgArray[Math.floor(Math.random() * 3)]);
			// set the position and the graphic to the image
			super(x, y,imgCrate);
			setHitbox(imgCrate.width,82);
		}
		//------------------------------------------------GAME LOOP
		//------------------------------------------------PUBLIC METHODS
	}

}