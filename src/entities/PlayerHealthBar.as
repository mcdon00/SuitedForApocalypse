package entities 
{
	import net.flashpunk.Entity;
	import flash.geom.Point;
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
	public class PlayerHealthBar extends Entity 
	{
		public var playerHealth:Image;
		public var maxHealth:Number;
		public var label:Text;
		
		public function PlayerHealthBar(x:Number,y:Number,health:Number) 
		{
			super(x, y);
			maxHealth = health;
			label = new Text("Player Health");
			
			label.size = 20;
			createHealthBar();
			label.x = playerHealth.width / 2 - label.width / 2;
			label.y = playerHealth.height / 2 - label.height / 2;
		}
		
		public function createHealthBar():void {
			playerHealth = new Image(new BitmapData(maxHealth, 30));
			playerHealth.color = 0xff0000;
			graphic = playerHealth;
			this.addGraphic(label);
		}
		
		public function updateHealthBar(currentHealth:Number):void {
			var percentHP:Number = currentHealth / maxHealth;
			playerHealth.scaleX = percentHP;
			
		}
	}

}