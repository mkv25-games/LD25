package game;
import com.eclecticdesignstudio.motion.Actuate;
import core.interfaces.IScreen;
import core.Screen;
import core.Signal;
import laboratory.HumanResources;
import laboratory.LaboratoryScreen;
import laboratory.rewards.RewardScreens;
import laboratory.Rooms;
import laboratory.Scores;
import nme.Assets;
import nme.display.Sprite;
import nme.media.Sound;
import nme.media.SoundTransform;
import title.TitleScreen;

class Game extends Screen
{
	public var title:TitleScreen;
	public var laboratory:LaboratoryScreen;
	
	public var top:Screen;
	
	public function new() 
	{
		super();
		
		// define static models
		Global.rewardScreens = new RewardScreens();
		Global.scores = new Scores();
		Global.humanResources = new HumanResources();
		Global.rooms = new Rooms();
		
		// define modules
		title = addModule(TitleScreen);
		laboratory = addModule(LaboratoryScreen);
		
		// wire up module commands
		addCommand(title.complete, laboratory.show);
		addCommand(laboratory.requestFocus, giveFocus);
		addCommand(title.requestFocus, giveFocus);
		
		giveFocus(title);
		
		// sound
		Actuate.timer(4.0).onComplete(playSound);
	}
	
	var sound:Sound;
	var soundVolume:SoundTransform;
	function playSound():Void
	{
		if (sound == null)
			sound = Assets.getSound("assets/beep.mp3");
		
		if (soundVolume == null)
			soundVolume = new SoundTransform(0.5);
		
		sound.play(0, 0, soundVolume);
		
		Actuate.timer(4.0).onComplete(playSound);
	}
	
	public function addModule(type:Class<Dynamic>):Dynamic
	{
		var module = Type.createInstance(type, []);
		addChild(module);
		
		return module;
	}
	
	public function addCommand(signal:Signal, command:Dynamic -> Void):Void
	{
		signal.add(command);
	}
	
	public function giveFocus(screen:Screen):Void
	{
		if (top != null) 
		{
			removeChild(top);
		}
		screen.gainedFocus(top);
		top = screen;
		addChild(screen);
	}
	
}