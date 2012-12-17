package laboratory.rooms;
import core.Signal;
import game.Global;
import laboratory.interfaces.IRoomProcess;
import laboratory.rewards.RewardScreens;
import laboratory.Room;
import laboratory.Scores;
import laboratory.TestSubject;

class MedicalRoomProcess extends StandardProcess
{	
	public function new()  
	{
		super();
	}
	
	override public function process(employees:List<TestSubject>):Void
	{
		if (scores.moneyScore.value < -1000)
			return;
		
		var cost:Float = 0;
		for (employee in employees)
		{
			if (employee.physicalAbility.value < employee.physicalAbility.max)
			{
				employee.physicalAbility.add(5);
				cost += 5;
			}
			
			if (employee.mentalAbility.value < employee.mentalAbility.max)
			{
				employee.mentalAbility.add(5);
				cost += 5;
			}
			
			if (employee.geneticQuality.value < 0)
			{
				employee.geneticQuality.add(5);
				cost += 5;
			}
			
			if (cost > 0)
			{
				employee.sanity.subtract(1);
				employee.drawHealthBar();
			}
		}
		
		if (cost > 0)
		{
			scores.moneyScore.subtract(cost);
			
			rewardScreens.showImage(RewardScreens.RS06_MEDICAL_WARD);
		}
		
		processed.dispatch(this);
	}
	
	override public function roomFrame():Int
	{
		return RoomFrames.MEDICAL;
	}
	
}