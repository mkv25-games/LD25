package laboratory;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import core.Signal;
import laboratory.interfaces.IRoomProcess;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Vector;

class Room extends Sprite 
{
	public var boundary:Rectangle;
	public var roomProcess:IRoomProcess;
	public var highlightColour:Int;
	public var offset:Int;
	public var employees:List<TestSubject>;
	
	public var highlighted:Signal;
	
	public function new(name:String, x:Float, y:Float, width:Float, height:Float, type:Class<Dynamic>) 
	{
		super();
		
		this.name = name;
		boundary = new Rectangle(x, y, width, height);
		roomProcess = Type.createInstance(type, []);
		
		highlightColour = 0xFFFFFF;
		offset = 0;
		employees = new List<TestSubject>();
		
		highlighted = new Signal();
		
		draw();
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.CLICK, onMouseClick);
		
		hide();
		mouseEnabled = false;
	}
	
	function draw():Void
	{
		var g = this.graphics;
		g.clear();
		
		g.beginFill(highlightColour);
		g.drawRect(boundary.x, boundary.y, boundary.width, boundary.height);
		g.endFill();
	}
	
	public function highlight(?args:Dynamic):Void
	{
		alpha = 0.1;
		highlighted.dispatch(this);
	}
	
	public function hide(?args:Dynamic):Void
	{
		alpha = 0.0;
	}
	
	public function flash(?args:Dynamic):Void
	{
		draw();
		
		mouseEnabled = false;
		alpha = 0.0;
		Actuate.timer(offset * 0.1).onComplete(doFlash);
	}
	
	function doFlash():Void
	{
		Actuate.tween(this, 0.1, { alpha: 0.9 } ).reflect().repeat(7).ease(Quad.easeIn).autoVisible(false).onComplete(onFlashComplete);
	}
	
	function onFlashComplete():Void
	{
		mouseEnabled = true;
	}
	
	public function assignCenter(point:Point):Void
	{
		point.x = boundary.x + (boundary.width / 2);
		point.y = boundary.y + (boundary.height / 2);
	}
	
	public function assignRandomWithinBounds(point:Point):Void
	{
		var padding:Int = 20;
		var x = boundary.x + padding;
		var y = boundary.y + padding;
		var w = boundary.width - (padding * 2);
		var h = boundary.height - (padding * 2);
		
		point.x = x + Math.random() * w;
		point.y = y + Math.random() * h;
	}
	
	function onMouseOver(e:MouseEvent):Void
	{
		highlight();
	}
	
	function onMouseOut(e:MouseEvent):Void
	{
		hide();
	}
	
	function onMouseClick(e:MouseEvent):Void
	{
		highlight();
		
		roomProcess.requestPurchase();
	}
	
	public function employeeAdded(employee:TestSubject):Void
	{
		employees.push(employee);
	}
	
	public function employeeRemoved(employee:TestSubject):Void
	{
		employees.remove(employee);
	}
	
	public function process(?args:Dynamic):Void
	{
		if (employees.length > 0)
			roomProcess.process(employees);
	}
}