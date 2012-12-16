package laboratory.rooms;
import core.Signal;
import game.Global;
import laboratory.interfaces.IRoomProcess;
import laboratory.Room;
import laboratory.Scores;
import laboratory.TestSubject;

class StandardProcess implements IRoomProcess
{
	@global var scores:Scores;
	
	public var processed:Signal;
	public var upgraded:Signal;
	
	public function new()  
	{
		scores = Global.scores;
		
		processed = new Signal();
		upgraded = new Signal();
	}
	
	public function process(employees:List<TestSubject>):Void
	{
		
	}
	
	public function requestPurchase(?args:Dynamic):Void
	{
		var cost:Float = purchaseCost();
		if (scores.moneyScore.value > cost)
		{
			scores.moneyScore.subtract(cost);
			upgraded.dispatch(this);
		}
	}
	
	public function purchaseName():String
	{
		var cost:Float = purchaseCost();
		if (scores.moneyScore.value < cost)
		{
			return "Upgrade Requires $" + cost; 
		}
		else if (cost > 0)
		{
			return "Upgrade for $" + cost;
		}
		else
		{
			return "No upgrade available";
		}
	}
	
	public function purchaseCost():Float
	{
		return 0;
	}
	
	public function roomFrame():Int
	{
		return RoomFrames.EMPTY1;
	}
}