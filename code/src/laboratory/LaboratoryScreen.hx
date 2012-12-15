package laboratory;

import com.eclecticdesignstudio.motion.Actuate;
import core.Screen;
import core.Signal;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;

class LaboratoryScreen extends Screen
{
	public var layerPeople:Sprite;
	public var layerDecals:Sprite;
	
	public var ready:Signal;
	public var rooms:Rooms;
	public var humanResources:HumanResources;
	
	public function new() 
	{
		super();
		
		layerPeople = new Sprite();
		layerDecals = new Sprite();
		
		ready = new Signal();
		screen.bitmapData = Assets.getBitmapData("assets/laboratory.png");
		rooms = new Rooms();
		humanResources = new HumanResources();
		
		addChild(screen);
		addChild(layerPeople);
		addChild(layerDecals);
		addChild(rooms);
		
		humanResources.recruitArrived.add(onRecruitArrived);
		humanResources.recruitDied.add(onRecruitDied);
		
		visible = false;
	}
	
	public function show(?args:Dynamic):Void
	{
		visible = true;
		screen.alpha = 0.0;
		Actuate.tween(screen, 2.0, { alpha: 1.0 } ).onComplete(onShowComplete).delay(1.0);
		
		requestFocus.dispatch(this);
	}
	
	function onShowComplete():Void
	{
		ready.dispatch(this);
		
		rooms.flashAllRooms();
		
		// recruit the initial test subjects
		for (i in 0...8)
		{
			Actuate.timer(i * 0.4).onComplete(humanResources.recruitTestSubject);
		}
	}
	
	function onRecruitArrived(hr:HumanResources):Void
	{
		var recruit = hr.newestRecruit();
		recruit.room = rooms.waitingRoom;
		layerPeople.addChild(recruit);
		
		rooms.waitingRoom.assignRandomWithinBounds(recruit.target);
		recruit.x = recruit.target.x;
		recruit.y = recruit.target.y;
		
		recruit.fallen.add(onRecruitFallen);
		
		recruit.draw();
		recruit.fadeIn();
	}
	
	function onRecruitDied(hr:HumanResources):Void
	{
		var recruit = hr.freshestCorpse();
		
		Actuate.timer(1.0).onComplete(moveRecruitToRecycling, [recruit]);
	}
	
	function moveRecruitToRecycling(recruit:TestSubject):Void
	{
		moveRecruitToRoom(recruit, rooms.recyclingRoom);		
		Actuate.timer(35).onComplete(recruit.fadeOut);
	}
	
	function moveRecruitToRoom(recruit:TestSubject, room:Room):Void
	{
		recruit.room = room;
		room.assignRandomWithinBounds(recruit.target);
		recruit.x = recruit.target.x;
		recruit.y = recruit.target.y;
	}
	
	function onRecruitFallen(recruit:TestSubject):Void
	{
		for (room in rooms.rooms)
		{
			if (room.boundary.contains(recruit.x, recruit.y))
			{
				moveRecruitToRoom(recruit, room);
				return;
			}
		}
		
		moveRecruitToRoom(recruit, rooms.waitingRoom);
	}
}