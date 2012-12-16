package core;
import nme.Assets;
import nme.text.TextField;

class Text 
{
	public static function makeTextField(fontId:String, size:Int, color:Int, align:Dynamic):TextField
	{
		var tf:TextField = new TextField();
		
		var format = tf.defaultTextFormat;
		var font = Assets.getFont(fontId);
		format.font = font.fontName;
		format.size = size;
		format.color = color;
		format.align = align;
		
		var text = tf;
		text.defaultTextFormat = format;
		text.setTextFormat(format);
		text.embedFonts = true;
		text.mouseEnabled = false;
		text.selectable = false;
		
		return tf;
	}
}