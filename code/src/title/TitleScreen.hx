package title;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import core.interfaces.IScreen;
import core.Screen;
import core.Signal;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.MouseEvent;

class TitleScreen extends Screen
{
	public var animationFinished:Bool;
	
	public var complete:Signal;
	public var ready:Signal;
	
	public function new() 
	{
		super();
		
		complete = new Signal();
		ready = new Signal();
		
		screen.bitmapData = Assets.getBitmapData("assets/title.png");
		screen.alpha = 0.0;
		
		addChild(screen);
		
		addEventListener(MouseEvent.CLICK, onClick);
	}
	
	override public function gainedFocus(from:IScreen):Void 
	{
		super.gainedFocus(from);
		
		beginAnimation();
	}
	
	public function beginAnimation():Void
	{
		screen.alpha = 0.0;
		Actuate.tween(screen, 2.0, { alpha: 1.0 } ).ease(Quad.easeInOut).onComplete(onFadeComplete).delay(1.0);
	}
	
	public function onFadeComplete():Void
	{
		animationFinished = true;
		ready.dispatch(this);
	}
	
	public function onClick(e:MouseEvent):Void
	{
		if (animationFinished)
		{
			complete.dispatch(this);
		}
	}
	
}