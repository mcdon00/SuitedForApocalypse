package entities 
{
	import flash.system.System;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Graphiclist;
	
	/**
	 * ...
	 * @author Nathan
	 */
	public class Button extends Entity 
	{
		//-------------------------------------------------CONSTANTS
		
		// button images
		[Embed(source = '../../assets/playBtn.png')] private const PLAY_IMG:Class;
		[Embed(source = '../../assets/resumeBtn.png')] private const RESUME_IMG:Class;
		[Embed(source = '../../assets/instructionsBtn.png')] private const INSTRUCTIONS_IMG:Class;
		[Embed(source = '../../assets/quitBtn.png')] private const QUIT_IMG:Class;
		// constants for buttom functions
		private const STR_PLAY:String = "play";
		private const STR_RESUME:String = "resume";
		private const STR_INSTRUCTIONS:String = "instructions";
		private const STR_QUIT:String = "quit";
		
		//-------------------------------------------------PROPERTIES
		// button image variable, it's type and a global menu world object
		public var imgButton:Image;
		public var btnType:String;
		public var menuWorld:MenuWorld;
		//-------------------------------------------------CONSTRUCTOR
		public function Button(x:Number,y:Number,myType:String,menu:MenuWorld) 
		{
			// set the position
			super(x, y);
			// set the type and grab the passed in menu world object
			btnType = myType;
			menuWorld = menu;
		
			// check the type passed and grab the image accordingly 
			if (btnType == STR_PLAY) imgButton = new Image(PLAY_IMG);
			if (btnType == STR_RESUME) imgButton = new Image(RESUME_IMG);
			if (btnType == STR_INSTRUCTIONS) imgButton = new Image(INSTRUCTIONS_IMG);
			if (btnType == STR_QUIT) imgButton = new Image(QUIT_IMG);
			
			// set the width and height, the hitbox and the graphic
			width = imgButton.width;
			height= imgButton.height;
			setHitbox(width,height);
			graphic = imgButton;
			
		}
		//-------------------------------------------------GAME LOOP
		override public function update():void {
			// check if mouse clicked
			if (Input.mousePressed) {
				// check if it was clicked inside this button
				if ((Input.mouseX >= x && Input.mouseX <= x + width) && (Input.mouseY >= y && Input.mouseY <= y + height)) {
					//check this buttons type and perform the appropriate function
					if (btnType == STR_PLAY) {
						FP.world = new GameWorld();
					}else if (btnType == STR_QUIT) {
						System.exit(0);
					}else if (btnType == STR_INSTRUCTIONS) {
						menuWorld.instVisable = true; 
					}
				}
			}
			super.update();
		}
	}

}