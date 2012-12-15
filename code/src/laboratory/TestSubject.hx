package laboratory;
import com.eclecticdesignstudio.motion.Actuate;
import core.Signal;
import core.SpriteSheet;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.Vector;
import nme.Vector;

class TestSubject extends Sprite
{
	public static var sprites(getSprites, null):SpriteSheet;
	
	inline static var FRAME_STANDING:Int = 0; 
	inline static var FRAME_WALK_ONE:Int = 1;
	inline static var FRAME_WALK_TWO:Int = 2;
	inline static var FRAME_PICKED_UP:Int = 3;
	inline static var FRAME_FALLEN:Int = 4;
	inline static var FRAME_DEAD:Int = 5;
	
	public var artwork:Bitmap;
	public var frame:Int;
	public var columnOffset:Int = 0;
	public var target:Point;
	public var room:Room;
	
	public var standing:Signal;
	public var walking:Signal;
	public var pickedUp:Signal;
	public var fallen:Signal;
	public var dead:Signal;
	public var thinking:Signal;
	
	var walkPosition:Int;
	var walkFrames:Vector<Int>;
	
	public function new(type:Int = 0) 
	{
		super();
		
		artwork = new Bitmap();
		frame = FRAME_STANDING;
		columnOffset = type;
		target = new Point();
		
		standing = new Signal();
		walking = new Signal();
		pickedUp = new Signal();
		fallen = new Signal();
		dead = new Signal();
		thinking = new Signal();
		
		addChild(artwork);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
		walkPosition = 0;
		walkFrames = new Vector();
		var frames = [FRAME_WALK_ONE, FRAME_STANDING, FRAME_WALK_TWO, FRAME_STANDING];
		for (frame in frames)
			walkFrames.push(frame);
		
		think();
	}
	
	public function draw():Void
	{
		if (artwork.stage == null)
			return;
		
		artwork.bitmapData = sprites.getXY(columnOffset, frame);
		
		artwork.scaleX = artwork.scaleY = 0.5;
		artwork.x = -(artwork.width / 2);
		artwork.y = - artwork.height;
	}
	
	public function wander():Void
	{
		if (room != null)
		{
			target.x = room.boundary.x + (Math.random() * room.boundary.width);
			target.y = room.boundary.y + (Math.random() * room.boundary.height);
		}
	}
	
	public function walk():Void
	{
		frame = walkFrames[walkPosition % walkFrames.length];
		walkPosition++;
		if (walkPosition >= cast walkFrames.length)
			walkPosition = 0;
		
		target.x = Math.floor(target.x);
		target.y = Math.floor(target.y);
		
		x = Math.floor(x);
		y = Math.floor(y);
		
		if (x < target.x) x++;
		if (x > target.x) x--;
		if (y < target.y) y++;
		if (y > target.y) y--;
		
		if (x == target.x && y == target.y)
		{
			frame = FRAME_STANDING;
		}
		
		walking.dispatch(this);
		
		draw();
	}
	
	public function stand():Void
	{
		frame = FRAME_STANDING;
		
		standing.dispatch(this);
		
		draw();
	}
	
	public function pickUp():Void
	{
		frame = FRAME_PICKED_UP;
		
		startDrag();
		pickedUp.dispatch(this);
		draw();
	}
	
	public function drop():Void
	{
		if (frame == FRAME_DEAD)
			return;
			
		frame = FRAME_FALLEN;
		
		stopDrag();
		fallen.dispatch(this);
		
		draw();
	}
	
	public function kill():Void
	{
		frame = FRAME_DEAD;
		
		dead.dispatch(this);
		
		draw();
	}
	
	public function think():Void
	{
		if (frame == FRAME_PICKED_UP)
		{
			Actuate.timer(0.5).onComplete(think);
			return;
		}
		
		if (x != target.x || y != target.y)
		{
			Actuate.timer(0.1).onComplete(think);
			walk();
			return;
		}
		
		if (frame == FRAME_STANDING)
		{
			Actuate.timer(1.0 + Math.random() * 2.0).onComplete(think);
			wander();
			return;
		}
		
		if (frame == FRAME_FALLEN)
		{
			Actuate.timer(1.0).onComplete(think);
			stand();
			return;
		}
		
		if (frame == FRAME_DEAD)
		{
			return;
		}
		
		Actuate.timer(5.0).onComplete(think);
			
		thinking.dispatch(this);
	}
	
	public function fadeIn():Void
	{
		alpha = 0.0;
		Actuate.tween(this, 0.8, { alpha: 1.0 } );
	}
	
	public function fadeOut():Void
	{
		alpha = 0.0;
		Actuate.tween(this, 0.8, { alpha: 0.0 } ).autoVisible().onComplete(onFadeOutComplete);
	}
	
	function onFadeOutComplete():Void
	{
		frame = FRAME_DEAD;
		if (parent != null)
			parent.removeChild(this);
	}
	
	public static function getSprites():SpriteSheet
	{
		if (TestSubject.sprites == null)
			return TestSubject.sprites = new SpriteSheet("assets/test_subject.png", 100, 100, 8, 8);
		return TestSubject.sprites;
	}
	
	function onMouseDown(e:MouseEvent):Void
	{
		if(frame != FRAME_DEAD)
			pickUp();
	}
	
	function onMouseUp(e:MouseEvent):Void
	{
		drop();
	}
	
}