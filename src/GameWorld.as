package  
{
	import entities.Crate;
	import entities.Player;
	import entities.PlayerHealthBar;
	import entities.ScreenOverlay;
	import entities.Timer;
	import entities.Zombie;
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import entities.Lamp;
	import net.flashpunk.Sfx;

	
	/**
	 * ...
	 * @author Nathan
	 */
	public class GameWorld extends World 
	{
		//------------------------------------------------CONSTANTS
		//const for background image
		[Embed(source = '../assets/map.png')] private const BACKGROUND_IMG:Class;
		//const for background music
		[Embed(source = '../assets/sound/backgroundMusic.mp3')] public const MUSIC:Class;
		
		private const FLOOR:Number = FP.screen.height - 175;
		private const SPEED:Number = 175;
		private const NUM_OF_LAMPS:Number = 6;
		private const NUM_OF_CRATES:Number = 0;
		
		//------------------------------------------------PROPERTIES
		public var sfxMusic:Sfx = new Sfx(MUSIC);
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
		
		//player health bar
		protected var healthBar:PlayerHealthBar;
		
		//overlay class
		protected var overlay:ScreenOverlay;
		public var gameover:Boolean;
		
		protected var waveNum:Number;
		private var callOnce:Boolean;
		
		// survival time 
		public var survivalTime:Number;
		public var displayTimer:Timer;
	

		//------------------------------------------------CONSTRUCTOR
		public function GameWorld() 
		{
			
		}
		
		override public function begin():void {
			survivalTime = 0;
			displayTimer = new Timer(0, 0);
			
			
			
			gameover = true;
			timeToSpawn = 0;
			imgBackground = new Image(BACKGROUND_IMG);
			
			aryEntLamp = new Array();
			
			aryEntZombies = new Array();
			aryZombieSpawnPoints = new Array();
			numOfZombies = 40; 

			// create and populate an array of lamp entity
			var locationX:int = 300;
			for (var i:int = 0; i < NUM_OF_LAMPS; i++) {
				entLamp = new Lamp(locationX, 185);
				aryEntLamp.push(entLamp);
				locationX += 800;
			}
			
			trace(imgBackground.width + "------------");
			
			//create the crate obstacles
			aryEntCrate = new Array();
			 //create and populate and array of crate entities
			locationX = 800;
			numOfCrates = 0;
			var random:Number = 0 + Math.floor(Math.random() * NUM_OF_CRATES);
			var arr:Array = rndLocationsX(random,80,40); 
			for (i = 0; i < random; i++) {
				numOfCrates++;
				locationX = arr[i];
				entCrate = new Crate(locationX, 380);
				aryEntCrate.push(entCrate);
			}
			// create the player entity
			entPlayer = new Player(400, 374);
			
			//create the zombie entities
			//aryEntZombies = spawnZombies(numOfZombies);
			aryEntZombies = spawnZombies(numOfZombies,aryEntZombies);
			trace(numOfCrates + " number of crates");
			
			//init the player health bar
			healthBar = new PlayerHealthBar(550,20,200);
			
			
			// define the inputs for left and right movement
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			
			
			// add entities-------------
			
			
			//addbackground image
			addGraphic(imgBackground);
			
			//add player health bar
			add(healthBar);
			
			//add the player to the stage
			add(entPlayer);
			//add each of the zombies
			for (i = 0; i < aryEntZombies.length; i++) {
				add(aryEntZombies[i]);
			}
			
			for (i = 0; i < numOfCrates; i++) {
				add(aryEntCrate[i]);
			}
			//add each of the lamps to the stage
			for (i = 0; i < aryEntLamp.length; i++) {
				add(aryEntLamp[i]);
				
			}
			
			//init overlay class
			overlay = new ScreenOverlay(this);
			
			add(overlay);
			
			waveNum = 1;
			callOnce = true;
			
			add(displayTimer);
			sfxMusic.loop();
			sfxMusic.volume = 0.8;
		}
		
		//------------------------------------------------GAMELOOP
		
		override public function update():void {
			
		
		if (gameover && waveNum == 1) {
			timeToSpawn += FP.elapsed;
			overlay.callNewWave(waveNum);
			if (timeToSpawn >= 3) {
				overlay.removeOverlay();
				gameover = false;
				timeToSpawn = 0;
			}
			
		}
		
		// check if player has died, if so kill the game
		if (entPlayer.myHealth <= 0) {
			remove(healthBar);
			entPlayer.sprPlayer.play("death");
			entPlayer.state = "dead";
			
			if (entPlayer.sprPlayer.frame >= 132) {
				overlay.callGameOver(survivalTime);
				gameover = true;
			}
			
		}
		
		if (!gameover) {
			entPlayer.sprPlayer.color = 0xffffff;
			//check if all zombies are eliminated
			//trace(this.classCount(Zombie));
			survivalTime += FP.elapsed;
			//TODO format this time display
			displayTimer.setTime(Math.round(survivalTime*100)/100);
			
			if (this.classCount(Zombie) <= 0) {
				
				if (callOnce) waveNum++;
				callOnce = false;
				overlay.callNewWave(waveNum);
				timeToSpawn += FP.elapsed;
				trace(timeToSpawn);
				trace(classCount(Zombie) + "-----------");
				if (timeToSpawn >= 5) {
					numOfZombies *= 2;
					aryEntZombies = spawnZombies(numOfZombies,aryEntZombies);
					
					var playerXMiddle:Number = entPlayer.x + (entPlayer.width / 2);
					for (var i:int = 0; i < aryEntZombies.length; i++) {
						//add(aryEntZombies[i]);
						var distanceFromZombie:Number = Math.abs(playerXMiddle - aryEntZombies[i].x);
						
						if (distanceFromZombie > 500) {
							add(aryEntZombies[i]);
							trace("ADDED" + aryEntZombies[i].x);
						}						
					}
					timeToSpawn = 0;
					callOnce = true;
					overlay.removeOverlay();
				}
				//trace(this.classCount(Zombie));
			}
			
			//if zombie is attacking
			for (var index:String in aryEntZombies) {
				if (aryEntZombies[index].isAttacking) {
					if (aryEntZombies[index].x > entPlayer.centerX) {
						trace("attacking right");
						moveWorldLeft(800);
						entPlayer.sprPlayer.color = 0xff0000;
						entPlayer.myHealth -= 5;
						healthBar.updateHealthBar(entPlayer.myHealth);
					}else {
						trace("attacking left");
						moveWorldRight(800);
						entPlayer.sprPlayer.color = 0xff0000;
						entPlayer.myHealth -= 5;
						healthBar.updateHealthBar(entPlayer.myHealth);
					}
				}
				
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
					
					if (Input.check("left")) {
						if(entPlayer.state != "dead")moveWorldLeft(SPEED);
					}else {
						if (entPlayer.state != "dead") moveWorldRight(SPEED);
					}
				}else if (Input.check("left")) {
					
					if (Input.check("right")) {
						if(entPlayer.state != "dead")moveWorldRight(SPEED);
					}else {
						if (entPlayer.state != "dead") moveWorldLeft(SPEED);
					}
				}
				
			super.update();
			}
		}
		//------------------------------------------------PUBLIC METHODS
		// function to spawn all of the zombies in the stage
		/*  must check to make sure that zombies wont spawn from spawn points that the player is close to
		 * zombies will be spawned randomly in random numbers from each spawn point
		 * each wave of zombies will gradually increase with a cap after a certain number of waves
		 * a check will also have to be done in the objects generation to ensure obstacles are not spawned at zombie 
		 * spawn points*/
		public function spawnZombies(numToSpawn:int, myZombies:Array):Array {
			//create zombies array to work with
			var zombies:Array = new Array();
			var myLocations:Array = new Array();
			// create a locations to spawn for the number of locations to spawn
			var locToSpawn:Number = 0;
			//which is the old array plus the new count
			locToSpawn = numToSpawn + myZombies.length;
			// a variable to hold each zombies position
			var posX:Number = 0;
			//start and end locations of the map
			var startMap:Number = imgBackground.x+800;
			var endMap:Number = imgBackground.x + imgBackground.width-200;
			// generate each posistion for each zombie, check to make sure it is not inside a crate
			for (var i:int = 0; i < locToSpawn; i++) 
			{
				//generate a random number within the map bounds and some buffer
				posX = Math.floor(startMap + (Math.random() * (endMap - startMap)));
				//while the generated number is inside a crate regenerate it
				for (var l:int = 0; l < aryEntCrate.length; l++) 
				{
					var isDup:Boolean = false;
					//trace(posX + " : "+ aryEntCrate[l].x+"zombie crates--------------" + l);
					while (((posX + 100) > aryEntCrate[l].x)&&((posX-100) < (aryEntCrate[l].x+aryEntCrate[l].width))) 
					{
						
						//trace(posX + "in crate" + aryEntCrate[l].x);
						posX = Math.floor(startMap + (Math.random() * (endMap - startMap)));
						isDup = true;
					}
					if (isDup) l = -1;
				}
				
				myLocations.push(posX);
			}
			
			// spawn new zombies 
			for (var k:int = 0; k < numToSpawn; k++) 
			{
				entZombie = new Zombie(0, 374, Zombie.TYPE_TSHIRT_ZOMBIE, entPlayer, imgBackground);
				zombies.push(entZombie);
			}
			// merge the new array of zombies with the old
			zombies = zombies.concat(myZombies);
			
			
			//for each of the zombies, new and old assign the locations
			for (var j:int = 0; j < zombies.length; j++) 
			{
				zombies[j].x = myLocations[j];
			}
			aryEntZombies = zombies;
			entPlayer.setZombies(aryEntZombies);
			return zombies;
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