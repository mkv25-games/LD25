package core.interfaces;
import core.Signal;

interface IScreen 
{
	var requestFocus:Signal;
	function lostFocus(to:IScreen):Void;
	function gainedFocus(from:IScreen):Void;
}