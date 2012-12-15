package core;
import nme.Assets;
import nme.display.BitmapData;
import nme.events.KeyboardEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Vector;

class SpriteSheet 
{
	public var sprites(getSprites, null):Vector<BitmapData>;
	var _sprites:Vector<BitmapData>;
	
	public var asset:String;
	public var width:Int;
	public var height:Int;
	public var columns:Int;
	public var rows:Int;
	
	public function new(asset:String, width:Int, height:Int, expectedColumns:Int = 0, expectedRows:Int = 0) 
	{
		this.asset = asset;
		this.width = width;
		this.height = height;
		
		this.columns = expectedColumns;
		this.rows = expectedRows;
	}
	
	public function get(i:Int):BitmapData
	{
		return sprites[i];
	}
	
	public function getXY(i:Int, j:Int):BitmapData
	{
		var index:Int = (j * columns) + i;
		return sprites[index];
	}
	
	function readSprites():Void
	{
		_sprites = new Vector<BitmapData>();
		
		var source:BitmapData = Assets.getBitmapData(asset);
		
		var cols:Int = Math.round(source.width / width);
		var rows:Int = Math.round(source.height / height);

		var r:Rectangle = new Rectangle(0, 0, width, height);
		var p:Point = new Point();
		var sprite:BitmapData;
		for (j in 0...rows)
		{
			for (i in 0...cols)
			{
				r.x = i * width;
				r.y = j * height;
				sprite = new BitmapData(width, height, true, 0xFF0000);
				sprite.copyPixels(source, r, p);
				sprites.push(sprite);
			}
		}
		
		this.columns = cols;
		this.rows = rows;
	}
	
	function getSprites():Vector<BitmapData>
	{
		if (_sprites != null)
		{
			return _sprites;
		}
		
		readSprites();		
		
		return _sprites;
	}
}