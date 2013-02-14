package  
{
	import entities.Crate;
	import entities.Player;
	import entities.Zombie;
	import net.flashpunk.Entity;
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
		private const SPEED:Number = 150;
		private const NUM_OF_LAMPS:Number = 7;
		private const NUM_OF_CRATES:Number = 5;
		private const ZOMBIE_SPAWN_POINTS:Array = [1350, 1950, 2750, 3450];
		
		//------------------------------------------------PROPERTIES
		//variableto hold background image
		public var imgBackground:Image;
		//lamp,player zombie objects
		public var entLamp:Lamp;
		public var aryEntLamp:Array;
		public var entPlayer:Player;
		public var entZombie:Zombie;
		public var aryEntZombies:Array;
		
		//obstacles
		public var entCrate:Crate;
		public var aryEntCrate:Array;
		public var numOfCrates:int;
		
		//------------------------------------------------CONSTRUCTOR
		public function GameWorld() 
		{
			imgBackground = new Image(BACKGROUND_IMG);
			aryEntLamp = new Array();
			aryEntZombies = new Array();
			// create and populate and array of lamp entity
			var locationX:int = 300;
			for (var i:int = 0; i < NUM_OF_LAMPS; i++) {
				entLamp = new Lamp(locationX, 180);
				aryEntLamp.push(entLamp);
				locationX += 800;
			}
			
			//create the crate obstacles
			aryEntCrate = new Array();
			 //create and populate and array of crate entities
			locationX = 800;
			numOfCrates = 0;
			var random:Number = Math.floor(Math.random() * NUM_OF_CRATES) +5;
			var arr:Array = rndLocationsX(random,84,48); 
			for (i = 0; i < random; i++) {
				numOfCrates++;
				locationX = arr[i];
				entCrate = new Crate(locationX, 380);
				aryEntCrate.push(entCrate);
			}
			
			// create the player entity
			entPlayer = new Player(300, 374);
			
			//create the zombie entities
			aryEntZombies = spawnZombies(5);
			entZombie = new Zombie(400, 374, Zombie.TYPE_TSHIRT_ZOMBIE,entPlayer);
			entCrate = new Crate(480, 380);
			
			
			// define the inputs for left and right movement
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right",Key.D,Key.RIGHT);
		}
		
		override public function begin():void {
			//addbackground image
			addGraphic(imgBackground);
			//add the player to the stage
			add(entPlayer);
			//add each of the zombies
			for (var i:int = 0; i < aryEntZombies.length; i++) {
				add(aryEntZombies[i]);
			}
			add(entZombie);
			//add(entCrate);
			
			
			
			for (i = 0; i < numOfCrates; i++) {
				add(aryEntCrate[i]);
			}
			//add each of the lamps to the stage
			for (i = 0; i < aryEntLamp.length-1; i++) {
				add(aryEntLamp[i]);
				
			}
			
			
		}
		
		//------------------------------------------------GAMELOOP
		
		override public function update():void {
	
			//TODO check for escape key, if pressed send back to main menu
				//crate/player collision detection
				var c:Crate = entPlayer.collide("crate", entPlayer.x, entPlayer.y) as Crate;
				var isCollideLeft:Boolean = false;
				var isCollideRight:Boolean = false;
				if (c != null) {
					if (c && ((entPlayer.y + entPlayer.height) > c.y +15)) {
					
						if ((c.x < entPlayer.x + entPlayer.width)&&(c.x > entPlayer.x)) {
							isCollideLeft = true;
						}else if ((c.x + c.width >= entPlayer.x)) {
							isCollideRight = true;
						}
					}
				}
				
				//player/zombie collision detection
				var z:Zombie = entPlayer.collide(Zombie.TYPE_TSHIRT_ZOMBIE, entPlayer.x, entPlayer.y) as Zombie;
				if (z != null) {
					
					if (z && ((entPlayer.y + entPlayer.height) > z.y +15)) {
					
						if ((z.x < entPlayer.x + entPlayer.width-15)&&(z.x > entPlayer.x)) {
							isCollideLeft = true;
						}else if ((z.x + z.width >= entPlayer.x)&&(z.x < entPlayer.x)) {
							isCollideRight = true;
							
						}
						
					}
				}
				
				if (Input.check("right")) {
					//check for end of map, if not at end move the map under the player
					if (!(entPlayer.x + entPlayer.width >= imgBackground.x +imgBackground.width -50)) {
						isCollideRight = false;
						if (!isCollideLeft) {
							
							//move the map with the player movement
							imgBackground.x -= SPEED * FP.elapsed;
							//move each of the lamps with the player movement
							for (var i:int = 0; i < aryEntLamp.length - 1; i++) {
								aryEntLamp[i].x -= SPEED * FP.elapsed;
							}
							//move each of the zombie spawn points with the player movement
							for (i = 0; i < ZOMBIE_SPAWN_POINTS.length - 1; i++) {
								ZOMBIE_SPAWN_POINTS[i] -= SPEED * FP.elapsed;
							}
							//move the crates with the map
							for (i = 0; i < numOfCrates; i++) {
								aryEntCrate[i].x -= SPEED * FP.elapsed;
							}
							
							//move zombies with map
							for (i = 0; i < aryEntZombies.length; i++) {
								aryEntZombies[i].x -= SPEED * FP.elapsed;
							}
							entZombie.x -= SPEED * FP.elapsed;
						}
					}
				}
				
				if (Input.check("left")) {
					//check for end of map, if not at end move the map under the player
					if (!(entPlayer.x <= imgBackground.x + 75)) {
						if (!isCollideRight){
							//move the map with the player movement
							imgBackground.x += SPEED * FP.elapsed;
							entLamp.x += SPEED * FP.elapsed;
							//move each of the lamps with the player movement
							for (i = 0; i < aryEntLamp.length - 1; i++) {
								aryEntLamp[i].x += SPEED * FP.elapsed;
							}
							//move each of the zombie spawn points with the player movement
							for (i = 0; i < ZOMBIE_SPAWN_POINTS.length - 1; i++) {
								ZOMBIE_SPAWN_POINTS[i] += SPEED * FP.elapsed;
							}
							//move the crates with the map
							for (i = 0; i < numOfCrates; i++) {
								aryEntCrate[i].x += SPEED * FP.elapsed;
							}
							//move zombies with map
							for (i = 0; i < aryEntZombies.length; i++) {
								aryEntZombies[i].x += SPEED * FP.elapsed;
							}
							entZombie.x += SPEED * FP.elapsed;
							
						}
					}
				}
				
			super.update();
		}
		//------------------------------------------------PUBLIC METHODS
		// function to spawn all of the zombies in the stage
		/*  must check to make sure that zombies wont spawn from spawn points that the player is close to
		 * zombies will be spawned randomly in random numbers from each spawn point
		 * each wave of zombies will gradually increase with a cap after a certain number of waves
		 * a check will also have to be done in the objects generation to ensure obstacles are not spawned at zombie 
		 * spawn points*/
		public function spawnZombies(numToSpawn:int):Array {
			
			var playerXMiddle:Number = entPlayer.x + (entPlayer.width / 2);
			
			for (var i:int = 0; i < ZOMBIE_SPAWN_POINTS.length; i++) 
			{
				var distanceFromSpawn:Number = Math.abs(playerXMiddle - ZOMBIE_SPAWN_POINTS[i]);
				if (distanceFromSpawn > 500) {
					for (var j:int = 0; j < numToSpawn ; j++) 
					{
						entZombie = new Zombie(ZOMBIE_SPAWN_POINTS[i], 374, Zombie.TYPE_TSHIRT_ZOMBIE,entPlayer);
						aryEntZombies.push(entZombie);
					}
				}
			}
			return aryEntZombies;
		}
		//function to generate random locations, used for obstacles
		//function generates a random number within a certain range specified but then multiplyed by the width
		//of the object that is being placed, this is to ensure each location is a multiple of the width
		// and thus wont be overlapping unless the exact same number is generated, in which case there is a 
		//condition to fix that
		public function rndLocationsX(numOfLocations:int, entWidth:Number, range:Number):Array {
			var posX:Number = 0;
			var aryPastLocations:Array = new Array();
			var aryLocations:Array = new Array();
			for (var j:int = 0; j < numOfLocations; j++) 
			{
				posX = 800+ (Math.floor(Math.random() * range)) * entWidth;
				trace(posX);
				//TODO space them apart further to fix being able to jump on the side of boxes when they are close together
				for (var i:int = 0; i < aryPastLocations.length; i++) 
				{
					while (aryPastLocations[i] == posX || posX < FP.screen.width) {
						posX = 800+ (Math.floor(Math.random() * range)) * entWidth;
					}						
				}
				aryPastLocations.push(posX);
				aryLocations.push(posX);
			}
			return aryLocations;
		}
	}
}