package  
{
	import entities.Button;
	import entities.Lamp;
	import net.flashpunk.utils.Input;
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
		[Embed(source = '../assets/instructions.png')] private const INSTRUCTIONS_IMG:Class;
		//------------------------------------------------PROPERTIES
		//background image avriable
		public var imgBackground:Image = new Image(BACKGROUND_IMG);
		public var imgInstructions:Image;
		//------------------------------------------------ENTITIES
		//lamp
		public var entLamp:Lamp;
		// buttons
		public var entPlayBtn:Button;
		public var entResumeBtn:Button;
		public var entInstructionsBtn:Button;
		public var entQuitBtn:Button;
		public var entInstBtn:Button;
		public var instVisable:Boolean;
		//------------------------------------------------CONSTRUCTOR
		public function MenuWorld() 
		{
			instVisable = false;
			imgInstructions = new Image(INSTRUCTIONS_IMG);
			imgInstructions.x = FP.screen.width / 2 - imgInstructions.width/2;
			imgInstructions.y = FP.screen.height / 2 - imgInstructions.height / 2;
			imgInstructions.visible = false;
			entPlayBtn = new Button(FP.screen.width / 2 - 90, 300, "play",this);
			entQuitBtn = new Button(FP.screen.width / 2 - 90, 350, "instructions",this);
			entInstBtn = new Button(FP.screen.width / 2 - 90, 400, "quit",this);
			entLamp = new Lamp(100, 168);
		}
		override public function begin():void {
			addGraphic(imgBackground);
			add(entLamp);
			add(entPlayBtn);
			add(entInstBtn);
			add(entQuitBtn);
			addGraphic(imgInstructions);
		}
		//------------------------------------------------GAME LOOP
		override public function update():void {
			if (instVisable) {
				imgInstructions.visible = true;
			}else {
				imgInstructions.visible = false;
			}
			if (Input.mousePressed) {
				instVisable = false;
			}
			super.update();
		}
	}
}