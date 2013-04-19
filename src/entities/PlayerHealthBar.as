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
		//-------------------------------------------------CONSTANTS
		//-------------------------------------------------PROPERTIES
		public var playerHealth:Image;
		public var maxHealth:Number;
		public var label:Text;
		//-------------------------------------------------CONSTRUCTOR
		public function PlayerHealthBar(x:Number,y:Number,health:Number) 
		{
			super(x, y);
			maxHealth = health;
			label = new Text("Health: %100");
			
			label.size = 20;
			createHealthBar();
			label.x = playerHealth.width / 2 - label.width / 2;
			label.y = playerHealth.height / 2 - label.height / 2;
		}
		//-------------------------------------------------METHODS
		// function to init the health bar
		public function createHealthBar():void {
			// create a new health bar image
			playerHealth = new Image(new BitmapData(maxHealth, 30));
			// set it's color to red
			playerHealth.color = 0xff0000;
			// set the graphic to the health bar rectangle and add some text
			graphic = playerHealth;
			this.addGraphic(label);
		}
		// function to update the health bar
		public function updateHealthBar(currentHealth:Number):void {
			// get the percentage of health left of the max health
			var percentHP:Number = currentHealth / maxHealth;
			// set the x scale of the red rectangle to the percentage
			playerHealth.scaleX = percentHP;
			// adjust the label inside the bar as well
			label.text ="Health: %" + Math.round(percentHP * 100);
		}
	}

}