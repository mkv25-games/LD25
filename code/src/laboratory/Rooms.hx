package laboratory;
import core.Signal;
import nme.display.Sprite;
import nme.Vector;
import nme.Vector;

class Rooms extends Sprite 
{
	public var requestFlash:Signal;
	public var requestHighlight:Signal;
	public var requestHide:Signal;
	
	public var rooms:Vector<Room>;
	
	public var waitingRoom:Room;
	public var recyclingRoom:Room;
	
	public var laboratoryA1:Room;
	public var laboratoryA2:Room;
	public var laboratoryA3:Room;
	
	public var laboratoryB1:Room;
	public var laboratoryB2:Room;
	public var laboratoryB3:Room;
	
	public function new() 
	{
		super();
		
		requestFlash = new Signal();
		requestHighlight = new Signal();
		requestHide = new Signal();
		
		rooms = new Vector<Room>();
		
		waitingRoom = createRoom("Waiting Room", 270, 100, 260, 90);
		recyclingRoom = createRoom("Recycling", 270, 230, 260, 90);
		
		laboratoryA1 = createRoom("Laboratory A1", 10, 100, 200, 90);
		laboratoryA2 = createRoom("Laboratory A2", 10, 230, 200, 90);
		laboratoryA3 = createRoom("Laboratory A3", 10, 360, 200, 90);
		
		laboratoryB1 = createRoom("Laboratory B1", 590, 100, 200, 90);
		laboratoryB2 = createRoom("Laboratory B2", 590, 230, 200, 90);
		laboratoryB3 = createRoom("Laboratory B3", 590, 360, 200, 90);
	}
	
	function createRoom(name:String, x:Float, y:Float, width:Float, height:Float):Room
	{
		var room = new Room(name, x, y, width, height);
		
		requestFlash.add(room.flash);
		requestHighlight.add(room.highlight);
		requestHide.add(room.hide);
		
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
}