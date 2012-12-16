package laboratory;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import core.Signal;
import core.SpriteSheet;
import laboratory.interfaces.IRoomProcess;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Vector;

class Room extends Sprite 
{
	public static var sprites(getSprites, null):SpriteSheet;
	
	public var boundary:Rectangle;
	public var roomProcess:IRoomProcess;
	
	public var highlightArea:Sprite;
	public var bitmap:Bitmap;
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
		
		highlightArea = new Sprite();
		bitmap = new Bitmap();
		highlightColour = 0xFFFFFF;
		offset = 0;
		employees = new List<TestSubject>();
		
		highlighted = new Signal();
		
		addChild(bitmap);
		addChild(highlightArea);
		draw();
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.CLICK, onMouseClick);
		
		hide();
		mouseEnabled = false;
	}
	
	function draw():Void
	{
		this.x = boundary.x;
		this.y = boundary.y;
		
		var g = highlightArea.graphics;
		g.clear();
		
		g.beginFill(highlightColour);
		g.drawRect(0, -30, boundary.width, boundary.height + 30);
		g.endFill();
		
		var frame = roomProcess.roomFrame();
		if (frame > -1)
		{
			bitmap.bitmapData = sprites.getXY(0, frame);
			bitmap.x = Math.floor(boundary.width / 2 - bitmap.width / 2);
			bitmap.y = boundary.height - bitmap.height;
		}
	}
	
	public function highlight(?args:Dynamic):Void
	{
		highlightArea.alpha = 0.1;
		highlighted.dispatch(this);
	}
	
	public function hide(?args:Dynamic):Void
	{
		highlightArea.alpha = 0.0;
	}
	
	public function flash(?args:Dynamic):Void
	{
		draw();
		
		mouseEnabled = false;
		highlightArea.alpha = 0.0;
		Actuate.timer(offset * 0.1).onComplete(doFlash);
	}
	
	function doFlash():Void
	{
		Actuate.tween(highlightArea, 0.1, { alpha: 0.9 } ).reflect().repeat(7).ease(Quad.easeIn).autoVisible(false).onComplete(onFlashComplete);
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
	
	public static function getSprites():SpriteSheet
	{
		if (Room.sprites == null)
			return Room.sprites = new SpriteSheet("assets/laboratory_rooms.png", 240, 120, 2, 4);
		return Room.sprites;
	}
}