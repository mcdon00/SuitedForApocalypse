package  
{
	import entities.Player;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import entities.Lamp;
	
	/**
	 * ...
	 * @author Nathan
	 */
	public class GameWorld extends World 
	{
		//------------------------------------------------CONSTANTS
		//const for background image
		[Embed(source = '../assets/map.png')] private const BACKGROUND_IMG:Class;
		private const FLOOR:Number = FP.screen.height - 175;
		private const SPEED:Number = 80;
		//------------------------------------------------PROPERTIES
		//variableto hold background image
		public var imgBackground:Image;
		//lamp,player objects
		public var entLamp:Lamp;
		public var entPlayer:Player;
		
		//------------------------------------------------CONSTRUCTOR
		public function GameWorld() 
		{
			imgBackground = new Image(BACKGROUND_IMG);//TODO Fix proportions in background, funeral home is tiny now, base the change off of the lamp size
			entLamp = new Lamp(200, 175);
			entPlayer = new Player(300, 374);
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right",Key.D,Key.RIGHT);
		}
		override public function begin():void {
			//addbackground image
			addGraphic(imgBackground);
			add(entLamp);
			add(entPlayer);
			
		}
		//------------------------------------------------GAMELOOP
		
		override public function update():void {
			//TODO check for escape key, if pressed send back to main menu
			
			if (Input.check("right")) {
				imgBackground.x -= SPEED * FP.elapsed;
				entLamp.x -= SPEED * FP.elapsed;
			}
			if (Input.check("left")) {
				imgBackground.x += SPEED * FP.elapsed;
				entLamp.x += SPEED * FP.elapsed;
			}
			
			
			super.update();
		}
		
	}

}