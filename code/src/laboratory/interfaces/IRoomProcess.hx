package laboratory.interfaces;
import core.Signal;
import laboratory.TestSubject;

interface IRoomProcess 
{
	var processed:Signal;
	var upgraded:Signal;
	function process(employees:List<TestSubject>):Void;
	
	function requestPurchase(?args:Dynamic):Void;
	function purchaseName():String;
	function purchaseCost():Float;
	function roomFrame():Int;
	function interact(recruit:TestSubject):Void;
}