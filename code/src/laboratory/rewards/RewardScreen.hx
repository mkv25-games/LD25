package laboratory.rewards;

import flash.display.Sprite;
import nme.display.Bitmap;
import nme.display.BitmapData;

class RewardScreen extends Sprite 
{
	public var bitmap:Bitmap;
	
	public function new(artwork:BitmapData) 
	{
		super();
		
		bitmap = new Bitmap(artwork);
		addChild(bitmap);
		
		bitmap.x = - Math.floor(bitmap.width / 2);
		bitmap.y = - Math.floor(bitmap.height / 2);
	}
	
}