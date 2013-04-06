package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Nathan
	 */
	public class Button extends Entity 
	{
		//-------------------------------------------------CONSTANTS
		[Embed(source = '../../assets/playBtn.png')] private const PLAY_IMG:Class;
		[Embed(source = '../../assets/resumeBtn.png')] private const RESUME_IMG:Class;
		[Embed(source = '../../assets/instructionsBtn.png')] private const INSTRUCTIONS_IMG:Class;
		[Embed(source = '../../assets/quitBtn.png')] private const QUIT_IMG:Class;
		
		private const STR_PLAY:String = "play";
		private const STR_RESUME:String = "resume";
		private const STR_INSTRUCTIONS:String = "instructions";
		private const STR_QUIT:String = "quit";
		
		//-------------------------------------------------PROPERTIES
		public var imgButton:Image;
		public var btnType:String;
		
		public function Button(x:Number,y:Number,myType:String) 
		{
			super(x, y);
			btnType = myType;
		
			
			if (btnType == STR_PLAY) imgButton = new Image(PLAY_IMG);
			if (btnType == STR_RESUME) imgButton = new Image(RESUME_IMG);
			if (btnType == STR_INSTRUCTIONS) imgButton = new Image(INSTRUCTIONS_IMG);
			if (btnType == STR_QUIT) imgButton = new Image(QUIT_IMG);
			
			
			width = imgButton.width;
			height= imgButton.height;
			setHitbox(width,height);
			graphic = imgButton;
			
		}
		
		override public function update():void {
			
			if (Input.mousePressed) {
				if (Input.mouseX >= x && Input.mouseX <= x + width) {
					if (Input.mouseY >= y && Input.mouseY <= y + height) {
						if (btnType == STR_PLAY) FP.world = new GameWorld();
						//if (btnType == STR_RESUME) FP.world = new GameWorld();
						//if (btnType == STR_INSTRUCTIONS) FP.world = new GameWorld();
						if (btnType == STR_QUIT) trace("asdad");
					}
				}
			} 
		}
	}

}