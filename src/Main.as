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
		public var zArray:Array;
		
		//------------------------------------------------CONSTRUCTOR
		public function Main():void 
		{
			
			//call the super class constructor and give it the screen dimensions
			super(800, 600);
			// TODO fix frame rate, have to adjust sprite sheet frame rates though
			//super(800, 600,60,true);
			
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