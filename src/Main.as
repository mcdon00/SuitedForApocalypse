package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	
	/**
	 * ...
	 * @author Nathan
	 */
	public class Main extends Engine 
	{
		//------------------------------------------------CONSTANTS
		//------------------------------------------------PROPERTIES
		// variables to hold menu world and game world
		public var mainMenu:MenuWorld;
		public var gameWorld:GameWorld;
		
		//------------------------------------------------CONSTRUCTOR
		public function Main():void 
		{
			
			//call the super class constructor and give it the screen dimensions
			super(800, 600);
			//init menu and game world objects
			mainMenu = new MenuWorld();
			gameWorld = new GameWorld();
			FP.console.enable();
			
		}
		//------------------------------------------------INIT
		public override function init():void 
		{
			//set the current world to the main menu world
			FP.world = mainMenu;
			
		}
		
		
	}
	
}