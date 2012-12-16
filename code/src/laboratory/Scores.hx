package laboratory;
import nme.display.Sprite;

class Scores extends Sprite 
{
	public var employeeScore:ScoreBox;
	public var deathScore:ScoreBox;
	public var researchScore:ScoreBox;
	public var moneyScore:ScoreBox;
	
	public function new() 
	{
		super();
		
		employeeScore = new ScoreBox("Employees", 0xFFFFFF, 118, 4,"E");
		deathScore = new ScoreBox("Deaths", 0xFF0000, 302, 4, "X");
		researchScore = new ScoreBox("Research", 0x738043, 502, 4, "R");
		moneyScore = new ScoreBox("Money", 0xDED9AD, 676, 4, "$");
		
		addChild(employeeScore);
		addChild(deathScore);
		addChild(researchScore);
		addChild(moneyScore);
	}
}