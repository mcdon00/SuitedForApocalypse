package  
{
	import entities.Crate;
	import entities.FloatingScore;
	import entities.HealthPack;
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
		// map movement speed
		private const SPEED:Number = 200;
		private const NUM_OF_LAMPS:Number = 6;
		private const NUM_OF_CRATES:Number = 1;
		
		//------------------------------------------------PROPERTIES
		public var sfxMusic:Sfx = new Sfx(MUSIC);
		//variableto hold background image
		public var imgBackground:Image;
		//lamp,player zombie objects
		public var entLamp:Lamp;
		public var aryEntLamp:Array;
		public var entPlayer:Player;
		//number of zombies
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
		public var healthBar:PlayerHealthBar;
		
		//overlay class
		protected var overlay:ScreenOverlay;
		public var gameover:Boolean;
		// variables for number of waves and a call onece boolean
		public var waveNum:Number;
		private var callOnce:Boolean;
		
		// survival time 
		public var survivalTime:Number;
		public var displayTimer:Timer;
		
		//score
		public var score:Number;
	

		//------------------------------------------------CONSTRUCTOR
		public function GameWorld() 
		{
			
		}
		
		override public function begin():void {
			// init timers and score
			survivalTime = 30;
			displayTimer = new Timer(0, 20);
			score = 0;
		
			gameover = true;
			timeToSpawn = 0;
			// set the background image
			imgBackground = new Image(BACKGROUND_IMG);
			// create arratys of lamps and zombies
			aryEntLamp = new Array();
			
			aryEntZombies = new Array();
			aryZombieSpawnPoints = new Array();
			//-------------------------------------number of zombies to start
			numOfZombies = 10; 
			// create and populate an array of lamp entity
			var locationX:int = 300;
			for (var i:int = 0; i < NUM_OF_LAMPS; i++) {
				entLamp = new Lamp(locationX, 185);
				aryEntLamp.push(entLamp);
				locationX += 800;
			}
			//create the crate obstacles
			aryEntCrate = new Array();
			 //create and populate and array of crate entities
			locationX = 800;
			//-------------------------------------number of obstacles to start, with at least three necessary
			numOfCrates = 0;
			// generate random number of crates
			var random:Number = 3 + (Math.floor(Math.random() * ((NUM_OF_CRATES - 3) + 1)));
			// generate random number of locations
			var arr:Array = rndLocationsX(random, 80, 40); 
			// for each crate create a crate entity and add it to the stage with the random locations
			for (i = 0; i < random; i++) {
				numOfCrates++;
				locationX = arr[i];
				entCrate = new Crate(locationX, 380);
				aryEntCrate.push(entCrate);
			}
			// create the player entity
			entPlayer = new Player(400, 374,this);
			
			//create the zombie entities\
			// spawn zombies randomly
			aryEntZombies = spawnZombies(numOfZombies,aryEntZombies);
			
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
			// add all the obstacles
			for (i = 0; i < numOfCrates; i++) {
				add(aryEntCrate[i]);
			}
			//add each of the lamps to the stage
			for (i = 0; i < aryEntLamp.length; i++) {
				add(aryEntLamp[i]);
				
			}
			
			//init overlay class
			overlay = new ScreenOverlay(this);
			// add the overlay
			add(overlay);
			// set the number of waves to 1
			waveNum = 1;
			callOnce = true;
			
			// add the display timer
			add(displayTimer);
			// start the background music
			sfxMusic.loop();
			// decrease the volume
			sfxMusic.volume = 0.7;
			
		}
		
		//------------------------------------------------GAMELOOP
		
		override public function update():void {
			
		// call the overlay for the first wave
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
		if ((entPlayer.myHealth <= 0) || (survivalTime <= 1)) {
			// remove the health bar
			remove(healthBar);
			entPlayer.sprPlayer.play("death");
			entPlayer.state = "dead";
			// when the player death animation is done call game over
			if (entPlayer.sprPlayer.frame >= 132) {
				overlay.callGameOver(score.toString());
				gameover = true;
			}	
		}
		// check if the game is not over
		if (!gameover) {
			entPlayer.sprPlayer.color = 0xffffff;
			//check if all zombies are eliminated
			// if they are regenerate a new wave
			if (this.classCount(Zombie) <= 0) {
				// increase the number of waves
				if (callOnce) waveNum++;
				callOnce = false;
				// call the new wave overlay
				overlay.callNewWave(waveNum);
				// increment the time to spawn timer
				timeToSpawn += FP.elapsed;
				var changeLevel:Boolean = true;
				// when the timer is greater than five seconds add more zombies and start the next wave
				if (timeToSpawn >= 5) {
					changeLevel = false;
					// add another half of zombies 
					numOfZombies = numOfZombies * 1.5;
					numOfZombies = Math.round(numOfZombies);
					// spawn more zombies
					aryEntZombies = spawnZombies(numOfZombies, aryEntZombies);
					// get the middle position of the player
					var playerXMiddle:Number = entPlayer.x + (entPlayer.width / 2);
					// run through each zombie and make sure none are near the player, if they are do not add them
					for (var i:int = 0; i < aryEntZombies.length; i++) {
						var distanceFromZombie:Number = Math.abs(playerXMiddle - aryEntZombies[i].x);
						if (distanceFromZombie > 500) {
							add(aryEntZombies[i]);
						}						
					}
					timeToSpawn = 0;
					callOnce = true;
					overlay.removeOverlay();
				}
			}
			if (!changeLevel) survivalTime -= FP.elapsed;
			// set the timer
			displayTimer.setTime(Math.round(survivalTime*100)/100,score);
			//if zombie is attacking
			for (var index:String in aryEntZombies) {
				if (aryEntZombies[index].isAttacking) {
					// check which side the zombie is attacking
					if (aryEntZombies[index].x > entPlayer.centerX) {
						takeHit("left");
						//moveWorldLeft(800);
						//entPlayer.sprPlayer.color = 0xff0000;
						//entPlayer.myHealth -= 5;
						//healthBar.updateHealthBar(entPlayer.myHealth);
					}else {
						takeHit("right");
						//moveWorldRight(800);
						//entPlayer.sprPlayer.color = 0xff0000;
						//entPlayer.myHealth -= 5;
						//healthBar.updateHealthBar(entPlayer.myHealth);
					}
				}
				
			}
			
			//crate/player collision detection
			var c:Crate = entPlayer.collide("crate", entPlayer.x, entPlayer.y) as Crate;
			// reset the collide booleans
			isCollideLeft= false;
			isCollideRight = false;
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
				if (Input.check(Key.D) && Input.check("right")) {
					if (entPlayer.state != "dead") moveWorldRight(SPEED);
				}else if (Input.check(Key.A) && Input.check("left")) {
					if (entPlayer.state != "dead") moveWorldLeft(SPEED);
				}
			}else {
				// when the game is over allow the enter button to be pressed so the game can be reset
				if (Input..check(Key.ENTER)) {
					FP.world = new MenuWorld();
					this.active = false;
					sfxMusic.stop();
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
				entZombie = new Zombie(0, 374, Zombie.TYPE_TSHIRT_ZOMBIE, entPlayer, imgBackground,this);
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
		// and wont be overlapping unless the exact same number is generated, in which case there is a 
		//condition to fix that
		public function rndLocationsX(numOfLocations:int, entWidth:Number, range:Number):Array {
			var posX:Number = 0;
			var aryPastLocations:Array = new Array();
			var aryLocations:Array = new Array();
			// generate locations randomly, cjeck for duplicates and regenerate
			for (var j:int = 0; j < numOfLocations; j++) {
				posX = 800 + (Math.floor(Math.random() * range)) * entWidth;
				for (var i:int = 0; i < aryPastLocations.length; i++) {	
					while (aryPastLocations[i] == posX) {
						posX = 800 + (Math.floor(Math.random() * range)) * entWidth;
					}						
				}
				// add all locations to array
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
					// move flaoting scores with map
					var aryFloatScores:Array = [];
					this.getClass(FloatingScore,aryFloatScores);
					for (i = 0; i < aryFloatScores.length; i++) {
						aryFloatScores[i].x += mySpeed * FP.elapsed;
					}
					// move health packs with map
					var aryHealthPacks:Array = [];
					this.getClass(HealthPack,aryHealthPacks);
					for (i = 0; i < aryHealthPacks.length; i++) {
						aryHealthPacks[i].x += mySpeed * FP.elapsed;
					}
				}
			}
		}
		public function moveWorldRight(mySpeed:Number):void {
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
					// move floating scores with map
					var aryFloatScores:Array = [];
					this.getClass(FloatingScore,aryFloatScores);
					for (i = 0; i < aryFloatScores.length; i++) {
						aryFloatScores[i].x -= mySpeed * FP.elapsed;
					}
					// move health pack with map
					var aryHealthPacks:Array = [];
					this.getClass(HealthPack,aryHealthPacks);
					for (i = 0; i < aryHealthPacks.length; i++) {
						aryHealthPacks[i].x -= mySpeed * FP.elapsed;
					}

				}
			}
		}
		// function to handle player recieving an attack from a zombie
		public function takeHit(side:String):void {
			// check which side attack is happening on move entities
			if (side == "left") {
				moveWorldLeft(800);
			}else {
				moveWorldRight(800);
			}
			// flash the player red
			entPlayer.sprPlayer.color = 0xff0000;
			// reduce player health
			entPlayer.myHealth -= 5;
			// update his health bar
			healthBar.updateHealthBar(entPlayer.myHealth);
		}
		
	}
}