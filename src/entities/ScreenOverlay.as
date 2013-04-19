package entities 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ScreenOverlay extends Entity 
	{
		//-------------------------------------------------CONSTANTS
		//-------------------------------------------------PROPERTIES
		// the overlay image background
		public var overLay:Image;
		// the text that appears over the over lay
		public var text:Text;
		//-------------------------------------------------CONSTRUCTOR
		public function ScreenOverlay(world:World) 
		{
			// set this object to be in the front of every other object
			this.layer = -1;
			// init the over lay
			overLay = new Image(new BitmapData(FP.screen.width, FP.screen.height));
		}
		///-------------------------------------------------METHODS
		//function to call the game over overlay
		public function callGameOver(time:String):void {
			// init the text objects
			text = new Text("Game Over");
			var surviveText:Text = new Text("Score: " + time);
			var pressEnter:Text = new Text("(press enter)");
			text.size = 80;
			text.x = FP.screen.width / 2 - text.width/2;
			text.y = FP.screen.height / 2;
			surviveText.x = FP.screen.width / 2 - surviveText.width / 2;
			surviveText.y = FP.screen.height / 2 + text.height;
			pressEnter.y = surviveText.y + surviveText.height;
			pressEnter.x = FP.screen.width / 2 - pressEnter.width / 2;
			// set the color to black and reduce the alpha
			overLay.color = 0x000000;
			overLay.alpha = 0.7;
			// set the graphic to the over lay and add the text graphics
			graphic = overLay;
			this.addGraphic(text);
			this.addGraphic(surviveText);
			this.addGraphic(pressEnter);
		}
		
		// funciton to call the wave overlay 
		public function callNewWave(waveNum:Number):void {
			// init the text objects
			text = new Text("Wave: "+waveNum);
			text.size = 80;
			text.x = FP.screen.width / 2 - text.width/2;
			text.y = FP.screen.height / 2;
			// set the overlay color and alpha
			overLay.color = 0x000000;
			overLay.alpha = 0.7;
			graphic = overLay;
			// add the text graphic
			this.addGraphic(text);
		}
		
		// function to remove the overlay when needed
		public function removeOverlay():void {
			this.graphic = null;
		}
	}

}