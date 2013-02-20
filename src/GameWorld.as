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
		private const NUM_OF_CRATES:Number = 10;

		
		
		
		//------------------------------------------------PROPERTIES
		//variableto hold background image
		public var imgBackground:Image;
		//lamp,player zombie objects
		public var entLamp:Lamp;
		public var aryEntLamp:Array;
		public var entPlayer:Player;
		public var numOfZombies:Number;
		public var entZombie:Zombie;
		public var aryEntZombies:Array;
		public var aryZombieSpawnPoints:Array;
		
		//obstacles
		public var entCrate:Crate;
		public var aryEntCrate:Array;
		public var numOfCrates:int;
		
		//boolean vars for colliding with othert iobjects
		protected var isCollideLeft:Boolean;
		protected var isCollideRight:Boolean;
		
		//timer for new wave of zombies
		protected var timeToSpawn:Number;

		//------------------------------------------------CONSTRUCTOR
		public function GameWorld() 
		{
			timeToSpawn = 0;
			imgBackground = new Image(BACKGROUND_IMG);
			
			aryEntLamp = new Array();
			
			aryEntZombies = new Array();
			aryZombieSpawnPoints = new Array();
			numOfZombies = 1; //time 4 (spawn points)

			// create and populate and array of lamp entity
			var locationX:int = 300;
			for (var i:int = 0; i < NUM_OF_LAMPS; i++) {
				entLamp = new Lamp(locationX, 180);
				aryEntLamp.push(entLamp);
				locationX += 800;
			}
			trace(imgBackground.width + "------------");
			
			//create the crate obstacles
			aryEntCrate = new Array();
			 //create and populate and array of crate entities
			locationX = 800;
			numOfCrates = 0;
			var random:Number = 8 + Math.floor(Math.random() * NUM_OF_CRATES);
			var arr:Array = rndLocationsX(random+4,120,30); //added four to number of crates to generate
			for (i = 4; i < random; i++) {//started adding crates from four
				numOfCrates++;
				locationX = arr[i];
				entCrate = new Crate(locationX, 380);
				aryEntCrate.push(entCrate);
			}
			for (i = 0; i < random-numOfCrates; i++) {
				aryZombieSpawnPoints[i] = arr[i];//used the first four spawn points in the generator for zombie spawn points
			}
			// create the player entity
			entPlayer = new Player(300, 374);
			
			//create the zombie entities
			aryEntZombies = spawnZombies(numOfZombies);
			entZombie = new Zombie(400, 374, Zombie.TYPE_TSHIRT_ZOMBIE,entPlayer,imgBackground);
			entCrate = new Crate(480, 380);
			
			trace(numOfCrates);
			trace(aryEntZombies.length);
			
			
			// define the inputs for left and right movement
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right",Key.D,Key.RIGHT);
		}
		
		override public function begin():void {
			//addbackground image
			addGraphic(imgBackground);
			//add the player to the stage
			add(entPlayer);
			//TODO need to create a new zombie spawn point generator. or use the old but include the crate locations as past generated
			//add each of the zombies
			for (var i:int = 0; i < aryEntZombies.length; i++) {
				add(aryEntZombies[i]);
				//trace("ADD ZOMBIE-----"+aryEntZombies[i].x);

			}
			//add(entZombie);
			//add(entCrate);
			
			for (i = 0; i < numOfCrates; i++) {
				add(aryEntCrate[i]);
				//trace("ADD CRATE-----"+aryEntCrate[i].x);
			}
			//add each of the lamps to the stage
			for (i = 0; i < aryEntLamp.length; i++) {
				add(aryEntLamp[i]);
				
			}
			
			
		}
		
		//------------------------------------------------GAMELOOP
		
		override public function update():void {
			//check if all zombies are eliminated
			//trace(this.classCount(Zombie));
			
			//TODO zombies still racing across screen or flickering when new wave is added
			if (this.classCount(Zombie) == 1) {
				for (var j:int = 0; j < aryEntZombies.length; j++) {
					if (aryEntZombies[j].myHealth > 0) {
						entZombie = aryEntZombies[j];
					}
				}
				//trace(entZombie.x + "--------------" + this.classCount(Zombie));
			}else {
				//trace(this.classCount(Zombie));
			}
			
			if (this.classCount(Zombie) <= 0) {
				timeToSpawn += FP.elapsed;
				//trace(timeToSpawn);
				if (timeToSpawn>=5){
					aryEntZombies.concat(spawnZombies(numOfZombies));
					var playerXMiddle:Number = entPlayer.x + (entPlayer.width / 2);
					for (var i:int = 0; i < aryEntZombies.length; i++) {
						for (var x:int = 0; x < aryZombieSpawnPoints.length; x++) 
						{
							
							var distanceFromSpawn:Number = Math.abs(playerXMiddle - aryZombieSpawnPoints[j]);
							if (distanceFromSpawn > 500) {
								 add(aryEntZombies[i]);
								 trace("ADDED" + aryEntZombies[i].x);
							}
						}
						
					}
					timeToSpawn = 0;
				}
				//trace(this.classCount(Zombie));
			}
			
			
			//TODO check for escape key, if pressed send back to main menu
				//crate/player collision detection
				var c:Crate = entPlayer.collide("crate", entPlayer.x, entPlayer.y) as Crate;
				isCollideLeft= false;
				isCollideRight= false;
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
				//move player left and right
				if (Input.check("right")) {
					moveWorldRight(SPEED);
				}
				
				if (Input.check("left")) {
					moveWorldLeft(SPEED);
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
			
			for (var i:int = 0; i < aryZombieSpawnPoints.length; i++) 
			{
				var distanceFromSpawn:Number = Math.abs(playerXMiddle - aryZombieSpawnPoints[i]);
				if (distanceFromSpawn > 500) {
					for (var j:int = 0; j < numToSpawn ; j++) 
					{
						entZombie = new Zombie(aryZombieSpawnPoints[i], 374, Zombie.TYPE_TSHIRT_ZOMBIE,entPlayer,imgBackground);
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
				posX = 800 + (Math.floor(Math.random() * range)) * entWidth;

				//TODO space them apart further to fix being able to jump on the side of boxes when they are close together
				for (var i:int = 0; i < aryPastLocations.length; i++) 
				{
					//TODO sometimes locations are still the same
					//MIGHT BE DUE TO THE LOCATIONS BEING GENERATED ON MAIN MENU THEN WHEN GAME WORLD IS LOADED
					while (aryPastLocations[i] == posX) {
						trace("DUP------------------" + posX);
						posX = 800 + (Math.floor(Math.random() * range)) * entWidth;
						trace("NEW------------------" + posX);
					}						
				}
				if (posX > 4815 ) {
					trace(posX+"----------------------OVER SIZE");
				}else {
					trace(posX);
				}
				
				aryPastLocations.push(posX);
				aryLocations.push(posX);
			}
			
			for (var k:int = 0; k < aryLocations.length ; k++) 
			{
				for (var l:int = 0; l < aryLocations.length; l++) 
				{
					if (aryLocations[l] != aryLocations[k]) {
						if (aryLocations[k] == aryLocations[l]) trace(aryLocations[k] + "-------------------------------------FOUND");
					}
				}
			}
			return aryLocations;
		}
		
		//a function to move the world and all of it's objects, as the player moves
		public function moveWorldLeft(mySpeed:Number):void 
		{
			//check for end of map, if not at end move the map under the player
			if (!(entPlayer.x <= imgBackground.x + 75)) {
				if (!isCollideRight){
					//move the map with the player movement
					imgBackground.x += mySpeed * FP.elapsed;
					//move each of the lamps with the player movement
					for (var i:int = 0; i < aryEntLamp.length; i++) {
						aryEntLamp[i].x += mySpeed * FP.elapsed;
					}
					//move each of the zombie spawn points with the player movement
					for (i = 0; i < aryZombieSpawnPoints.length; i++) {
						aryZombieSpawnPoints[i] += mySpeed * FP.elapsed;
					}
					//move the crates with the map
					for (i = 0; i < numOfCrates; i++) {
						aryEntCrate[i].x += mySpeed * FP.elapsed;
					}
					//move zombies with map
					for (i = 0; i < aryEntZombies.length; i++) {
						aryEntZombies[i].x += mySpeed * FP.elapsed;
					}
					//TEST ZOMBIE
					//entZombie.x += mySpeed * FP.elapsed;
					
				}
			}
		}
		public function moveWorldRight(mySpeed:Number):void 
		{
			//check for end of map, if not at end move the map under the player
			if (!(entPlayer.x + entPlayer.width >= imgBackground.x +imgBackground.width -50)) {
				if (!isCollideLeft) {
					
					//move the map with the player movement
					imgBackground.x -= mySpeed * FP.elapsed;
					//move each of the lamps with the player movement
					for (var i:int = 0; i < aryEntLamp.length; i++) {
						aryEntLamp[i].x -= mySpeed * FP.elapsed;
					}
					//move each of the zombie spawn points with the player movement
					for (i = 0; i < aryZombieSpawnPoints.length; i++) {
						aryZombieSpawnPoints[i] -= mySpeed * FP.elapsed;
					}
					//move the crates with the map
					for (i = 0; i < numOfCrates; i++) {
						aryEntCrate[i].x -= mySpeed * FP.elapsed;
					}
					
					//move zombies with map
					for (i = 0; i < aryEntZombies.length; i++) {
						aryEntZombies[i].x -= mySpeed * FP.elapsed;
					}
					
					//TEST ZOMBIE
					//entZombie.x -= mySpeed * FP.elapsed;
				}
			}
		}
	}
}