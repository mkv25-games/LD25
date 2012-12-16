package laboratory.rooms;
import core.Signal;
import game.Global;
import laboratory.interfaces.IRoomProcess;
import laboratory.Room;
import laboratory.Scores;
import laboratory.TestSubject;

class RecyclingRoomProcess extends StandardProcess
{	
	public var level:Int = 1;
	
	public function new()  
	{
		super();
	}
	
	override public function process(employees:List<TestSubject>):Void
	{		
		var profit:Float = 0;
		var research:Float = 0;
		var bonus:Float = levelBonus();
		for (employee in employees)
		{
			if (employee.physicalAbility.value > 0)
			{
				employee.physicalAbility.subtract(10);
				profit += bonus;
				research += bonus;
			}
			
			if (employee.mentalAbility.value > 0)
			{
				employee.mentalAbility.subtract(10);
				profit += bonus;
			}
			
			if (employee.geneticQuality.value > 0)
			{
				employee.geneticQuality.subtract(10);
				profit += bonus;
			}
			
			employee.sanity.subtract(100);
			employee.drawHealthBar();
		}
		
		if(profit > 0)
			scores.moneyScore.add(profit);
			
		if (research > 0)
			scores.researchScore.add(research);
			
		processed.dispatch(this);
	}
	
	override public function requestPurchase(?args:Dynamic):Void
	{
		var cost:Float = purchaseCost();
		if (scores.moneyScore.value >= cost)
		{
			scores.moneyScore.subtract(cost);
			level = level + 1;
			upgraded.dispatch(this);
		}
	}
	
	override public function purchaseName():String
	{
		var cost:Float = purchaseCost();
		if (scores.moneyScore.value < cost)
		{
			return "Requires $" + cost; 
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
	
	override public function purchaseCost():Float
	{
		return 100 * levelBonus();
	}
	
	function levelBonus():Float
	{
		return Math.pow(2, (level + 1));
	}
	
}