package laboratory;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Bounce;
import core.interfaces.IDrawable;
import core.Signal;
import core.SpriteSheet;
import core.Text;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.text.TextField;
import nme.text.TextFormatAlign;
import nme.Vector;
import nme.Vector;

class TestSubject extends Sprite, implements IDrawable
{
	public static var sprites(getSprites, null):SpriteSheet;
	
	inline static var FRAME_STANDING:Int = 0; 
	inline static var FRAME_WALK_ONE:Int = 1;
	inline static var FRAME_WALK_TWO:Int = 2;
	inline static var FRAME_PICKED_UP:Int = 3;
	inline static var FRAME_FALLEN:Int = 4;
	inline static var FRAME_DEAD:Int = 5;
	
	public var artwork:DisplayObject;
	public var sortDepth:Float;
	
	public var bitmap:Bitmap;
	public var healthBar:Sprite;
	public var healthText:TextField;
	public var frame:Int;
	public var columnOffset:Int = 0;
	public var target:Point;
	public var room:Room;
	public var walkSpeed:Float;
	public var isSelected:Bool;
	public var isStunned:Bool;
	
	public var standing:Signal;
	public var walking:Signal;
	public var pickedUp:Signal;
	public var fallen:Signal;
	public var dead:Signal;
	public var thinking:Signal;
	
	public var drawn:Signal;
	public var selected:Signal;
	
	public var physicalAbility:TestAttribute;
	public var mentalAbility:TestAttribute;
	public var geneticQuality:TestAttribute;
	public var sanity:TestAttribute;
	
	var walkPosition:Int;
	var walkFrames:Vector<Int>;
	
	public function new(type:Int = 0) 
	{
		super();
		
		artwork = this;
		
		bitmap = new Bitmap();
		healthBar = new Sprite();
		healthText = Text.makeTextField("assets/trebuchet-bold.ttf", 16, 0xFFFFFF, TextFormatAlign.CENTER);
		frame = FRAME_STANDING;
		columnOffset = type;
		target = new Point();
		room = null;
		walkSpeed = Math.random() * 500;
		isSelected = false;
		isStunned = false;
		
		standing = new Signal();
		walking = new Signal();
		pickedUp = new Signal();
		fallen = new Signal();
		dead = new Signal();
		thinking = new Signal();
		
		drawn = new Signal();
		selected = new Signal();
		
		physicalAbility = new TestAttribute("Physical Ability", 100, -100);
		mentalAbility = new TestAttribute("Mental Ability", 100, -100);
		geneticQuality = new TestAttribute("Genetic Quality", 100, -100);
		sanity = new TestAttribute("Sanity", 50, -50);
		
		addChild(bitmap);
		addChild(healthBar);
		healthBar.addChild(healthText);
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		
		walkPosition = 0;
		walkFrames = new Vector();
		var frames = [FRAME_WALK_ONE, FRAME_STANDING, FRAME_WALK_TWO, FRAME_STANDING];
		for (frame in frames)
			walkFrames.push(frame);
		
		think();
		mouseEnabled = false;
	}
	
	public function draw():Void
	{
		if (artwork.stage == null)
			return;
		
		bitmap.bitmapData = sprites.getXY(columnOffset, frame);
		
		bitmap.scaleX = bitmap.scaleY = 0.5;
		bitmap.x = -(bitmap.width / 2);
		bitmap.y = - bitmap.height;
		
		sortDepth = y + (x / 1000);
		drawn.dispatch(this);
	}
	
	public function drawHealthBar():Void
	{
		var g = healthBar.graphics;
		g.clear();
		
		var r = new Rectangle();
		r.width = 50;
		r.height = 10;
		r.x = - r.width / 2;
		r.y = - bitmap.height - r.height;
		
		g.beginFill(0xFF0000);
		g.drawRect(r.x, r.y, r.width, r.height);
		g.endFill();
		
		var s = calculateHealth();
		g.beginFill(0x738043);
		g.drawRect(r.x, r.y, r.width * s, r.height);
		g.endFill();
		
		var format = healthText.defaultTextFormat;
		var font = Assets.getFont("assets/orator.otf");
		format.font = font.fontName;
		
		var text = healthText;
		text.text = name;
		text.width = r.width + 40;
		text.height = 20;
		text.x = - text.width / 2;
		text.y = -bitmap.height - text.height - r.height;
		
		g.beginFill(0x000000, 0.5);
		g.drawRect(text.x, text.y, text.width, text.height);
		g.endFill();
	}
	
	public function wander():Void
	{
		if (room != null)
		{
			room.assignRandomWithinBounds(target);
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
		select();
		draw();
	}
	
	public function drop():Void
	{
		if (frame == FRAME_DEAD)
			return;
			
		isStunned = true;
		
		frame = FRAME_FALLEN;
		
		stopDrag();
		fallen.dispatch(this);
		
		draw();
		drawHealthBar();
		
		Actuate.timer(0.6).onComplete(unstun);
	}
	
	public function unstun():Void
	{
		isStunned = false;
	}
	
	public function kill():Void
	{
		frame = FRAME_DEAD;
		
		dead.dispatch(this);
		
		draw();
	}
	
	public function think():Void
	{
		if (isStunned)
		{
			Actuate.timer(0.5).onComplete(think);
			return;
		}
		
		var health = calculateHealth();
		if (health <= 0)
		{
			kill();
			return;
		}
		
		if (frame == FRAME_PICKED_UP)
		{
			Actuate.timer(0.5).onComplete(think);
			return;
		}
		
		if (x != target.x || y != target.y)
		{
			Actuate.timer(0.2 - Math.min(walkSpeed / 1000, 0.1)).onComplete(think);
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
		
		Actuate.timer(2.0).onComplete(think);
			
		thinking.dispatch(this);
	}
	
	public function fadeIn():Void
	{
		alpha = 0.0;
		Actuate.tween(this, 0.8, { alpha: 1.0 } ).onComplete(onFadeInComplete);
	}
	
	function onFadeInComplete():Void
	{
		mouseEnabled = true;
	}
	
	public function fadeOut():Void
	{
		Actuate.tween(this, 0.8, { alpha: 0.0 } ).autoVisible().onComplete(onFadeOutComplete);
	}
	
	function onFadeOutComplete():Void
	{
		frame = FRAME_DEAD;
		if (parent != null)
			parent.removeChild(this);
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
	
	function onMouseOver(e:MouseEvent):Void
	{
		healthBar.visible = true;
		drawHealthBar();
	}
	
	function onMouseOut(e:MouseEvent):Void
	{
		healthBar.visible = isSelected || false;
	}
	
	function calculateMaxTotal():Float
	{
		return sanity.max + physicalAbility.max + mentalAbility.max + geneticQuality.max;
	}
	
	function calculateHealth():Float
	{
		var maxTotal = Math.max(1, calculateMaxTotal());
		var sumTotal:Float = Math.max(0, sanity.value + physicalAbility.value + mentalAbility.value + geneticQuality.value);
		return sumTotal / maxTotal;
	}
	
	public function select():Void
	{
		isSelected = true;
		healthBar.visible = isSelected;
		selected.dispatch(this);
		drawHealthBar();
	}
	
	public function deselect():Void
	{
		isSelected = false;
		healthBar.visible = isSelected;
	}
	
	public static function getSprites():SpriteSheet
	{
		if (TestSubject.sprites == null)
			return TestSubject.sprites = new SpriteSheet("assets/test_subject.png", 100, 100, 8, 8);
		return TestSubject.sprites;
	}
	
}