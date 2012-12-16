package net.mkv25.ld25;

import game.Game;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author John Beech
 */

class Main extends Sprite 
{
	public var game:Game;
	
	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	private function init(e) 
	{
		// entry point
		game = new Game();
		addChild(game);
		
		stage.addEventListener(Event.RESIZE, resize);
	}
	
	private function resize(e:Event):Void
	{
		game.x = Math.floor(stage.stageWidth / 2 - game.width / 2);
		game.y = Math.floor(stage.stageHeight / 2 - game.height / 2);
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}
