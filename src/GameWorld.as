package  
{
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	
	/**
	 * ...
	 * @author Nathan
	 */
	public class GameWorld extends World 
	{
		//------------------------------------------------CONSTANTS
		//const for background image
		[Embed(source = '../assets/map.png')] private const BACKGROUND_IMG:Class;
		//------------------------------------------------PROPERTIES
		//variableto hold background image
		public var imgBackground:Image = new Image(BACKGROUND_IMG);//TODO Fix proportions in background, funeral home is tiny now, base the change off of the lamp size
		
		//------------------------------------------------CONSTRUCTOR
		public function GameWorld() 
		{
			//addbackground image
			addGraphic(imgBackground);
		}
		
		//------------------------------------------------GAMELOOP
		
		override public function update():void {
			//TODO check for escape key, if pressed send back to main menu
		}
	}

}