package laboratory;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import nme.display.Sprite;
import nme.geom.Point;
import nme.geom.Rectangle;

class Room extends Sprite 
{
	public var boundary:Rectangle;
	public var highlightColour:Int;
	public var offset:Int = 0;
	
	public function new(name:String, x:Float, y:Float, width:Float, height:Float) 
	{
		super();
		
		boundary = new Rectangle(x, y, width, height);
		highlightColour = 0xFFFFFF;
		
		var g = this.graphics;
		g.beginFill(highlightColour);
		g.drawRect(boundary.x, boundary.y, boundary.width, boundary.height);
		g.endFill();
		
		hide();
	}
	
	public function highlight(?args:Dynamic):Void
	{
		alpha = 0.5;
		visible = true;
	}
	
	public function hide(?args:Dynamic):Void
	{
		visible = false;
	}
	
	public function flash(?args:Dynamic):Void
	{
		alpha = 0.0;
		Actuate.timer(offset * 0.1).onComplete(doFlash);
	}
	
	function doFlash():Void
	{
		Actuate.tween(this, 0.1, { alpha: 0.9 } ).reflect().repeat(7).ease(Quad.easeIn);
	}
	
	public function assignCenter(point:Point):Void
	{
		point.x = boundary.x + (boundary.width / 2);
		point.y = boundary.y + (boundary.height / 2);
	}
	
	public function assignRandomWithinBounds(point:Point):Void
	{
		var padding:Int = 10;
		point.x = boundary.x + padding + ((boundary.width - padding * 2) * Math.random());
		point.y = boundary.y + padding + ((boundary.height - padding * 2) * Math.random());
	}
	
}