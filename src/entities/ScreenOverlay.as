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
		public var overLay:Image;
		public var text:Text;
		
		public function ScreenOverlay(world:World) 
		{
			this.layer = -1;
			overLay = new Image(new BitmapData(FP.screen.width, FP.screen.height));
		}
		
		public function callGameOver(time:String):void {
			
			text = new Text("Game Over");
			var surviveText:Text = new Text("Survival Time: " + time);
			var pressEnter:Text = new Text("(press enter)");
			text.size = 80;
			text.x = FP.screen.width / 2 - text.width/2;
			text.y = FP.screen.height / 2;
			surviveText.x = FP.screen.width / 2 - surviveText.width / 2;
			surviveText.y = FP.screen.height / 2 + text.height;
			pressEnter.y = surviveText.y + surviveText.height;
			pressEnter.x = FP.screen.width / 2 - pressEnter.width / 2;
			overLay.color = 0x000000;
			overLay.alpha = 0.7;
			graphic = overLay;
			this.addGraphic(text);
			this.addGraphic(surviveText);
			this.addGraphic(pressEnter);
		}
		
		
		public function callNewWave(waveNum:Number):void {
			
			text = new Text("Wave: "+waveNum);
			text.size = 80;
			text.x = FP.screen.width / 2 - text.width/2;
			text.y = FP.screen.height / 2;
			overLay.color = 0x000000;
			overLay.alpha = 0.7;
			graphic = overLay;
			this.addGraphic(text);
		}
		
		
		public function removeOverlay():void {
			this.graphic = null;
		}
	}

}