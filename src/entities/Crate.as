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
		[Embed(source = '../../assets/garbageCan.png')] private const CAN:Class;
		[Embed(source = '../../assets/mailbox.png')] private const MAIL:Class;
		//------------------------------------------------PROPERTIES
		public var imgCrate:Image;
		//------------------------------------------------CONSTRUCTOR
		public function Crate(x:Number,y:Number) 
		{
			var imgArray:Array = new Array();
			
			imgArray.push(CRATE);
			imgArray.push(CAN);
			imgArray.push(MAIL);
			
			Math.floor(Math.random()*3);
			
			type = "crate";
			//imgCrate = new Image(CRATE);
			imgCrate = new Image(imgArray[Math.floor(Math.random()*3)]);
			super(x, y,imgCrate);
			//setHitbox(80,82);
			setHitbox(imgCrate.width,82);
		}
		//------------------------------------------------GAME LOOP
		//------------------------------------------------PUBLIC METHODS
	}

}