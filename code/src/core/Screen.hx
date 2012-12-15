package core;
import core.interfaces.IScreen;
import nme.display.Bitmap;
import nme.display.Sprite;

class Screen extends Sprite, implements IScreen 
{
	public var requestFocus:Signal;
	public var screen:Bitmap;

	public function new() 
	{
		super();
		
		requestFocus = new Signal();
		screen = new Bitmap();
	}
	
	public function gainedFocus(from:IScreen):Void
	{
		visible = true;
	}
	
	public function lostFocus(to:IScreen):Void
	{
		visible = false;
	}
}