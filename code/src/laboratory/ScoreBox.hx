package laboratory;
import com.eclecticdesignstudio.motion.Actuate;
import core.Signal;
import core.Text;
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFormatAlign;

class ScoreBox extends Sprite 
{
	var text:TextField;
	
	var displayValue:Float;
	var suffix:String;
	
	public var value(default, null):Float;
	public var prefix:String;
	public var valueChanged:Signal;
	
	public function new(name:String, color:Int, x:Float, y:Float, prefix:String='') 
	{
		super();
		
		this.name = name;
		text = Text.makeTextField("assets/trebuchet.ttf", 32, color, TextFormatAlign.LEFT);
		text.width = 120;
		text.height = 52;
		this.x = x;
		this.y = y;
		
		value = 0;
		displayValue = 0;
		suffix = '';
		
		this.prefix = prefix;
		this.valueChanged = new Signal();
		
		addChild(text);
	}
	
	public function setValue(to:Float):Void
	{
		value = to;
		displayValue = value;
		valueChanged.dispatch(this);
		
		updateDisplayValue();
	}
	
	public function changeValue(to:Float):Void
	{
		var diff = Math.abs(value - to);
		value = to;
		if (diff < 2)
		{
			setValue(to);
			return;
		}
		else if (diff < 10)
		{
			Actuate.tween(this, 0.5, { displayValue:to } ).onUpdate(updateDisplayValue);
		}
		else
		{
			Actuate.tween(this, 1.5, { displayValue:to } ).onUpdate(updateDisplayValue);
		}
		
		valueChanged.dispatch(this);
	}
	
	function updateDisplayValue():Void
	{
		var v = Math.round(displayValue);
		suffix = '';
		
		if (v >= 1000)
		{
			v = Math.round(v / 1000);
			suffix = 'K';
		}
		
		if (v >= 1000)
		{
			v = Math.round(v / 1000);
			suffix = 'M';
		}
		
		if (v >= 1000)
		{
			v = Math.round(v / 1000);
			suffix = 'B';
		}
		
		if (v >= 1000)
		{
			v = Math.round(v / 1000);
			suffix = 'T';
		}
			
		text.text = prefix + v + suffix;
	}
	
	public function add(amount:Float):Void
	{
		changeValue(value + amount);
	}
	
	public function subtract(amount:Float):Void
	{
		changeValue(value - amount);
	}
	
}