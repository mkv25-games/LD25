package laboratory.rooms;
import game.Global;
import laboratory.HumanResources;
import laboratory.interfaces.IRoomProcess;

class RecruitmentProcess extends StandardProcess
{
	@global var humanResources:HumanResources;
	
	public function new() 
	{
		super();
		
		humanResources = Global.humanResources;
	}
	
	override public function requestPurchase(?args:Dynamic):Void
	{
		var cost = purchaseCost();
		if (scores.moneyScore.value >= cost)
		{
			humanResources.recruitTestSubject();
		}
	}
	
	override public function purchaseName():String
	{
		var cost:Float = purchaseCost();
		if (scores.moneyScore.value < cost)
		{
			return "Recruits cost $" + cost; 
		}
		else if (cost > 0)
		{
			return "Buy recruit $" + cost + "";
		}
		else
		{
			return "No employees available";
		}
	}
	
	override public function purchaseCost():Float
	{
		if (humanResources.testSubjects.length < 40)
		{
			return humanResources.testSubjectPrice();
		}
		return 0;
	}
	
	override public function roomFrame():Int 
	{
		return RoomFrames.NO_FRAME;
	}
	
}