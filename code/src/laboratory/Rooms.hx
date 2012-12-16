package laboratory;
import com.eclecticdesignstudio.motion.Actuate;
import core.Signal;
import core.Text;
import laboratory.rooms.MedicalRoomProcess;
import laboratory.rooms.RecruitmentProcess;
import laboratory.rooms.RecyclingRoomProcess;
import laboratory.rooms.StandardProcess;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.text.TextField;
import nme.text.TextFormatAlign;
import nme.Vector;
import nme.Vector;

class Rooms extends Sprite 
{
	public var requestFlash:Signal;
	public var requestHighlight:Signal;
	public var requestHide:Signal;
	public var requestProcess:Signal;
	
	public var rooms:Vector<Room>;
	
	public var waitingRoom:Room;
	public var recyclingRoom:Room;
	
	public var laboratoryA1:Room;
	public var laboratoryA2:Room;
	public var laboratoryA3:Room;
	
	public var laboratoryB1:Room;
	public var laboratoryB2:Room;
	public var laboratoryB3:Room;
	
	public var roomLabel:TextField;
	public var upgradeLabel:TextField;
	
	public var highlightedRoom:Room;
	
	public function new() 
	{
		super();
		
		requestFlash = new Signal();
		requestHighlight = new Signal();
		requestHide = new Signal();
		requestProcess = new Signal();
		
		rooms = new Vector<Room>();
		
		waitingRoom = createRoom("Waiting Room", 270, 100, 260, 90, RecruitmentProcess);
		recyclingRoom = createRoom("Recycling", 270, 230, 260, 90, RecyclingRoomProcess);
		recyclingRoom.highlightColour = 0xFF0000;
		
		laboratoryA1 = createRoom("Laboratory A1", 10, 100, 200, 90, StandardProcess);
		laboratoryA2 = createRoom("Laboratory A2", 10, 230, 200, 90, StandardProcess);
		laboratoryA3 = createRoom("Laboratory A3", 10, 360, 200, 90, StandardProcess);
		
		laboratoryB1 = createRoom("Medical", 590, 100, 200, 90, MedicalRoomProcess);
		laboratoryB2 = createRoom("Laboratory B2", 590, 230, 200, 90, StandardProcess);
		laboratoryB3 = createRoom("Laboratory B3", 590, 360, 200, 90, StandardProcess);
		
		roomLabel = Text.makeTextField("assets/trebuchet-bold.ttf", 24, 0x443333, TextFormatAlign.CENTER);
		roomLabel.width = 300;
		roomLabel.height = 40;
		roomLabel.x = 400 - roomLabel.width / 2;
		roomLabel.y = 500 - roomLabel.height - 70;
		
		upgradeLabel = Text.makeTextField("assets/trebuchet-bold.ttf", 20, 0xDED9AD, TextFormatAlign.CENTER);
		upgradeLabel.width = 300;
		upgradeLabel.height = 30;
		upgradeLabel.x = 400 - upgradeLabel.width / 2;
		upgradeLabel.y = 500 - upgradeLabel.height / 2 - 30;
		
		var upgradeButton:Sprite = new Sprite();
		var g = upgradeButton.graphics;
		g.beginFill(0x000000, 0.5);
		g.drawRect(0, 0, upgradeLabel.width, upgradeLabel.height);
		g.endFill();
		upgradeButton.x = upgradeLabel.x;
		upgradeButton.y = upgradeLabel.y;
		upgradeButton.addEventListener(MouseEvent.CLICK, onUpgradeClicked);
		
		addChild(roomLabel);
		addChild(upgradeButton);
		addChild(upgradeLabel);
		
		Actuate.timer(1.0).onComplete(processRooms);
	}
	
	function createRoom(name:String, x:Float, y:Float, width:Float, height:Float, type:Class<Dynamic>):Room
	{
		var room = new Room(name, x, y, width, height, type);
		
		requestFlash.add(room.flash);
		requestHighlight.add(room.highlight);
		requestHide.add(room.hide);
		requestProcess.add(room.process);
		
		room.highlighted.add(onRoomHighlighted);
		room.roomProcess.upgraded.add(onRoomProcessUpgraded);
		
		room.offset = rooms.length;
		rooms.push(room);
		
		addChild(room);
		
		return room;
	}
	
	public function flashAllRooms():Void
	{
		requestFlash.dispatch(this);
	}
	
	public function highlightAllRooms():Void
	{
		requestHighlight.dispatch(this);
	}
	
	public function hideAllRooms():Void
	{
		requestHide.dispatch(this);
	}
	
	public function processRooms():Void
	{
		requestProcess.dispatch(this);
		
		Actuate.timer(0.5).onComplete(processRooms);
	}
	
	function onUpgradeClicked(e:MouseEvent):Void
	{
		if (highlightedRoom != null)
		{
			var cost = highlightedRoom.roomProcess.purchaseCost();
			if (cost > 0)
			{
				highlightedRoom.roomProcess.requestPurchase();
				onRoomHighlighted(highlightedRoom);
			}
		}
	}
	
	function onRoomHighlighted(room:Room):Void
	{
		highlightedRoom = room;
		roomLabel.text = room.name;
		upgradeLabel.text = room.roomProcess.purchaseName();
	}
	
	function onRoomProcessUpgraded(?args:Dynamic):Void
	{
		if (highlightedRoom != null)
		{
			onRoomHighlighted(highlightedRoom);
		}
	}
}