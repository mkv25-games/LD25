package laboratory;
import core.Signal;
import nme.Vector;
import nme.Vector;

class HumanResources 
{
	public var testSubjects:Vector<TestSubject>;	
	public var deadRecruits:Vector<TestSubject>;
	
	public var recruitArrived:Signal;
	public var recruitDied:Signal;
	
	public var XNAME:String = "1234567890";
	public var YNAME:String = "ABCJKIXYZ";
	public var ZNAME:String = "DEFPQR+-$";
	
	public function new() 
	{
		testSubjects = new Vector<TestSubject>();
		deadRecruits = new Vector<TestSubject>();
		
		recruitArrived = new Signal();
		recruitDied = new Signal();
	}
	
	public function recruitTestSubject():Void
	{
		var type = Math.round(Math.random() * 1000) % 4;
		var recruit = new TestSubject(type);
		testSubjects.push(recruit);
		
		var index:Int = testSubjects.length + deadRecruits.length;
		var indexX:Int = Math.floor(index / 100);
		var indexY:Int = Math.floor(index / 10);
		var indexZ:Int = Math.floor(index);
		
		recruit.name = "TS" + XNAME.charAt(indexX % XNAME.length) + YNAME.charAt(indexY % YNAME.length) + ZNAME.charAt(indexZ % ZNAME.length);
		
		recruit.dead.add(onRecruitDead);
		
		recruitArrived.dispatch(this);
	}
	
	public function newestRecruit():TestSubject
	{
		if(testSubjects.length > 0)
			return testSubjects[testSubjects.length - 1];
		
		return null;
	}
	
	public function freshestCorpse():TestSubject
	{
		if(deadRecruits.length > 0)
			return deadRecruits[deadRecruits.length - 1];
		
		return null;
	}
	
	function onRecruitDead(recruit:TestSubject):Void
	{
		var index = testSubjects.indexOf(recruit);
		testSubjects.splice(index, 1);
		
		deadRecruits.push(recruit);
		recruit.dead.remove(onRecruitDead);
		
		recruitDied.dispatch(this);
	}
}