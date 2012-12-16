package core.interfaces;

import core.Signal;
import nme.display.DisplayObject;

interface IDrawable 
{
	public var drawn:Signal;
	public var artwork:DisplayObject;
	public var sortDepth:Float;
}