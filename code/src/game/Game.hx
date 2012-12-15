package game;
import core.interfaces.IScreen;
import core.Screen;
import core.Signal;
import laboratory.LaboratoryScreen;
import nme.display.Sprite;
import title.TitleScreen;

class Game extends Screen
{
	public var title:TitleScreen;
	public var laboratory:LaboratoryScreen;
	
	public var top:Screen;
	
	public function new() 
	{
		super();
		
		title = addModule(TitleScreen);
		laboratory = addModule(LaboratoryScreen);
		
		addCommand(title.complete, laboratory.show);
		addCommand(laboratory.requestFocus, giveFocus);
		addCommand(title.requestFocus, giveFocus);
		
		giveFocus(title);
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