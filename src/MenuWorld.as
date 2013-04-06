package  
{
	import entities.Button;
	import entities.Lamp;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	
	
	/**
	 * ...
	 * @author Nathan
	 */
	public class MenuWorld extends World 
	{	
		//------------------------------------------------CONSTANTS
		//const for background image
		[Embed(source = '../assets/mainMenu.png')] private const BACKGROUND_IMG:Class;
		
		//------------------------------------------------PROPERTIES
		//background image avriable
		public var imgBackground:Image = new Image(BACKGROUND_IMG);
	
		
		//------------------------------------------------ENTITIES
		//lamp
		public var entLamp:Lamp;
		public var entPlayBtn:Button;
		public var entResumeBtn:Button;
		public var entInstructionsBtn:Button;
		public var entQuitBtn:Button;
		//------------------------------------------------CONSTRUCTOR
		public function MenuWorld() 
		{
			entPlayBtn = new Button(FP.screen.width / 2 - 90, 300, "play");
			entQuitBtn = new Button(FP.screen.width/2-90,350,"quit");
			entLamp = new Lamp(100, 168);
		}
		override public function begin():void {
			addGraphic(imgBackground);
			add(entLamp);
			add(entPlayBtn);
			add(entQuitBtn);
		}
		//------------------------------------------------GAME LOOP
		
	}
}