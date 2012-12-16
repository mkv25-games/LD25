package laboratory;

class TestAttribute 
{
	public var name:String;
	
	public var value:Float;
	public var max:Float;
	public var min:Float;
	
	public function new(name:String, max:Float, min:Float) 
	{
		this.name = name;
		this.max = max;
		this.value = max;
		this.min = min;
	}
	
	public function constrain(newValue:Float):Float
	{
		value = newValue;
		
		if (value > max)
			value = max;
		
		if (value < min)
			value = min;
			
		return value;
	}
	
	public function add(amount:Float):Void
	{
		constrain(value + amount);
	}
	
	public function subtract(amount:Float):Void
	{
		constrain(value - amount);
	}
	
}