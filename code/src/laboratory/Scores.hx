package laboratory;
import game.Global;
import laboratory.rewards.RewardScreens;
import nme.display.Sprite;

class Scores extends Sprite 
{
	@global var rewardScreens:RewardScreens;
	
	public var employeeScore:ScoreBox;
	public var deathScore:ScoreBox;
	public var researchScore:ScoreBox;
	public var moneyScore:ScoreBox;
	
	public function new() 
	{
		super();
		
		rewardScreens = Global.rewardScreens;
		
		employeeScore = new ScoreBox("Employees", 0xFFFFFF, 118, 4,"E");
		deathScore = new ScoreBox("Deaths", 0xFF0000, 302, 4, "X");
		researchScore = new ScoreBox("Research", 0x738043, 502, 4, "R");
		moneyScore = new ScoreBox("Money", 0xDED9AD, 676, 4, "$");
		
		employeeScore.valueChanged.add(checkEmployeeScore);
		deathScore.valueChanged.add(checkDeathScore);
		researchScore.valueChanged.add(checkResearchScore);
		moneyScore.valueChanged.add(checkMoneyScore);
		
		addChild(employeeScore);
		addChild(deathScore);
		addChild(researchScore);
		addChild(moneyScore);
	}
	
	function checkEmployeeScore(score:ScoreBox):Void
	{
		var value = score.value;
		
		if (value >= 30)
			rewardScreens.showImage(RewardScreens.RS20_EMPLOYEES_MAX);
	}
	
	function checkDeathScore(score:ScoreBox):Void
	{
		var value = score.value;
		
		if (value >= 1)
			rewardScreens.showImage(RewardScreens.RS02_DEATH_01);
		if (value >= 100)
			rewardScreens.showImage(RewardScreens.RS17_DEATH_02);
		if (value >= 500)
			rewardScreens.showImage(RewardScreens.RS18_DEATH_03);
		if (value >= 10000)
			rewardScreens.showImage(RewardScreens.RS19_DEATH_END);
	}
	
	function checkResearchScore(score:ScoreBox):Void
	{
		var value = score.value;
		
		if (value >= 1001)
			rewardScreens.showImage(RewardScreens.RS09_RESEARCH_01);
		if (value >= 150000)
			rewardScreens.showImage(RewardScreens.RS10_RESEARCH_02);
		if (value >= 500000)
			rewardScreens.showImage(RewardScreens.RS11_RESEARCH_03);
		if (value >= 1000000)
			rewardScreens.showImage(RewardScreens.RS12_RESEARCH_END);
	}
	
	function checkMoneyScore(score:ScoreBox):Void
	{
		var value = score.value;
		
		if (value >= 1000)
			rewardScreens.showImage(RewardScreens.RS13_MONEY_01);
		if (value >= 150000)
			rewardScreens.showImage(RewardScreens.RS14_MONEY_02);
		if (value >= 500000)
			rewardScreens.showImage(RewardScreens.RS15_MONEY_03);
		if (value >= 1000000)
		{
			rewardScreens.showImage(RewardScreens.RS16_MONEY_END);
			score.changeValue(0);
		}
	}
	
}