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
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Timer extends Entity 
	{
		//-------------------------------------------------CONSTANTS
		//-------------------------------------------------PROPERTIES
		// variables for text and number objects
		public var timer:Text;
		public var scoreKeep:Text;
		public var time:Number;
		public var score:Number;
		//-------------------------------------------------CONSTRUCTOR
		public function Timer(x:Number,y:Number) 
		{
			// set the time and scores
			time = 30;
			score = 0;
			// set the position
			super(x, y);
			// init the text and score objects
			timer = new Text("Time Left: " + convertToHHMMSS(time));
			scoreKeep = new Text("Score: " + score);
			scoreKeep.y = y + scoreKeep.height/2;
			scoreKeep.size = 20;
			timer.size = 20;
			// add the graphics
			graphic = timer;
			addGraphic(scoreKeep);
		}
		//-------------------------------------------------METHODS
		// function to set the current time and score
		public  function setTime(myTime:Number,myScore:Number):void {
			time = myTime;
			score = myScore;
			timer.text = "Time Left: " + convertToHHMMSS(time);
			scoreKeep.text = "Score: " + score;
		}
		// functions to convert time in seconds to hours minutes and seconds
		public function convertToHHMMSS($seconds:Number):String
		{
			var s:Number = $seconds % 60;
			var m:Number = Math.floor(($seconds % 3600 ) / 60);
			var h:Number = Math.floor($seconds / (60 * 60));
			 
			var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
			var minuteStr:String = doubleDigitFormat(m) + ":";
			var secondsStr:String = doubleDigitFormat(s);
			 
			return hourStr + minuteStr + secondsStr;
		}
		 
		public function doubleDigitFormat($num:uint):String
		{
			if ($num < 10) 
			{
				return ("0" + $num);
			}
			return String($num);
		}
	}

}