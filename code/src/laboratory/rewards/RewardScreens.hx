package laboratory.rewards;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import flash.display.Sprite;
import nme.Assets;
import nme.events.MouseEvent;

class RewardScreens extends Sprite
{	
	
	public static inline var RS01_EMPLOYEES:String = "assets/rs01.png";
	public static inline var RS02_DEATH_01:String = "assets/rs02.png";
	public static inline var RS03_ELECTRO_SHOCK:String = "assets/rs03.png";
	public static inline var RS04_GYMNASIUM:String = "assets/rs04.png";
	public static inline var RS05_VIRAL_MECHANISMS:String = "assets/rs05.png";
	public static inline var RS06_MEDICAL_WARD:String = "assets/rs06.png";
	public static inline var RS07_THE_ICE_BOX:String = "assets/rs07.png";
	public static inline var RS08_FUTURE_COOLING:String = "assets/rs08.png";
	public static inline var RS09_RESEARCH_01:String = "assets/rs09.png";
	public static inline var RS10_RESEARCH_02:String = "assets/rs10.png";
	public static inline var RS11_RESEARCH_03:String = "assets/rs11.png";
	public static inline var RS12_RESEARCH_END:String = "assets/rs12.png";
	public static inline var RS13_MONEY_01:String = "assets/rs13.png";
	public static inline var RS14_MONEY_02:String = "assets/rs14.png";
	public static inline var RS15_MONEY_03:String = "assets/rs15.png";
	public static inline var RS16_MONEY_END:String = "assets/rs16.png";
	public static inline var RS17_DEATH_02:String = "assets/rs17.png";
	public static inline var RS18_DEATH_03:String = "assets/rs18.png";
	public static inline var RS19_DEATH_END:String = "assets/rs19.png";
	public static inline var RS20_EMPLOYEES_MAX:String = "assets/rs20.png";
	
	var currentScreen:RewardScreen;
	var queue:List<RewardScreen>;
	var cover:Sprite;
	var index:Hash<Bool>;
	
	public function new() 
	{
		super();
		
		currentScreen = null;
		queue = new List<RewardScreen>();
		
		cover = new Sprite();
		var g = cover.graphics;
		g.beginFill(0x000000, 0.85);
		g.drawRect(0, 0, 800, 500);
		g.endFill();
		
		index = new Hash<Bool>();
	}
	
	public function alreadyDisplayed(id:String):Bool
	{
		return index.exists(id);
	}
	
	public function showImage(imageAsset:String):Void
	{
		if (alreadyDisplayed(imageAsset))
		{
			return;
		}
		
		var bitmapData = Assets.getBitmapData(imageAsset);
		var screen = new RewardScreen(bitmapData);
		show(screen);
		
		index.set(imageAsset, true);
	}
	
	public function show(screen:RewardScreen):Void
	{
		if (currentScreen != null)
		{
			queue.push(screen);
		}
		else
		{
			currentScreen = screen;
			currentScreen.addEventListener(MouseEvent.CLICK, onScreenClose);
			
			addChild(currentScreen);
			currentScreen.x = 400;
			currentScreen.y = -250;
			currentScreen.mouseEnabled = false;
			Actuate.tween(currentScreen, 0.8, { y:250 } ).ease(Quad.easeInOut).onComplete(unlockScreen, [currentScreen]);
		}
		
		if (queue.length == 0)
		{
			addChildAt(cover, 0);
			cover.alpha = 0.0;
			Actuate.tween(cover, 0.5, { alpha:1.0 } ).autoVisible(true).onComplete(onFadeIn);
		}
	}
	
	function onFadeIn():Void
	{
		// chill
	}
	
	function unlockScreen(screen:RewardScreen):Void
	{
		screen.mouseEnabled = true;
	}
	
	function onScreenClose(e:MouseEvent):Void
	{
		close();
	}
	
	public function close():Void
	{
		if (currentScreen != null)
		{
			currentScreen.removeEventListener(MouseEvent.CLICK, onScreenClose);
			removeChild(currentScreen);
			currentScreen = null;
		}
		
		if (queue.length > 0)
		{
			show(queue.pop());
		}
		else
		{
			Actuate.tween(cover, 0.5, { alpha:0.0 } ).autoVisible(true).onComplete(onFadeOut);
		}
	}
	
	function onFadeOut():Void
	{
		removeChild(cover);
	}
	
}