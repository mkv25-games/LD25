package laboratory;

import com.eclecticdesignstudio.motion.Actuate;
import core.interfaces.IDrawable;
import core.Screen;
import core.Signal;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Vector;

class LaboratoryScreen extends Screen
{
	public var layerPeople:Sprite;
	public var layerDecals:Sprite;
	
	public var ready:Signal;
	
	public var resortRequired:Bool;
	public var drawables:Vector<IDrawable>;
	public var rooms:Rooms;	
	public var humanResources:HumanResources;
	
	var selectedRecruit:TestSubject;
	
	public function new() 
	{
		super();
		
		layerPeople = new Sprite();
		layerDecals = new Sprite();
		
		ready = new Signal();
		
		screen.bitmapData = Assets.getBitmapData("assets/laboratory.png");
		resortRequired = false;
		drawables = new Vector<IDrawable>();
		rooms = new Rooms();
		humanResources = new HumanResources();
		
		addChild(screen);
		addChild(rooms);
		addChild(layerPeople);
		addChild(layerDecals);
		
		humanResources.recruitArrived.add(onRecruitArrived);
		humanResources.recruitDied.add(onRecruitDied);
		
		visible = false;
		
		sortDrawables();
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
			Actuate.timer(i * 0.15).onComplete(humanResources.recruitTestSubject);
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
		
		recruit.pickedUp.add(onRecruitPickedUp);
		recruit.fallen.add(onRecruitFallen);
		recruit.drawn.add(onRecruitDrawn);
		recruit.selected.add(onRecruitSelected);
		drawables.push(recruit);
		
		recruit.draw();
		recruit.fadeIn();
	}
	
	function onRecruitDied(hr:HumanResources):Void
	{
		var recruit = hr.freshestCorpse();
		
		recruit.fallen.remove(onRecruitFallen);
		recruit.drawn.remove(onRecruitDrawn);
		recruit.selected.remove(onRecruitSelected);
		
		var i = -1;
		for (k in drawables)
		{
			i++;
			if (k == recruit)
				break;
		}
		if(i >= 0)
		drawables.splice(i, 1);
		
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
	
	function onRecruitPickedUp(recruit:TestSubject):Void
	{
		addChild(recruit);
	}
	
	function onRecruitFallen(recruit:TestSubject):Void
	{
		layerPeople.addChild(recruit);
		
		var fallDamage:Float = 10 + Math.round(Math.random() * 40);
		recruit.physicalAbility.subtract(fallDamage);
		
		for (room in rooms.rooms)
		{
			if (room.boundary.contains(recruit.x, recruit.y))
			{
				recruit.room = room;
				recruit.target.x = recruit.x;
				recruit.target.y = recruit.y;
				// moveRecruitToRoom(recruit, room);
				return;
			}
		}
		
		moveRecruitToRoom(recruit, rooms.waitingRoom);
	}
	
	function onRecruitDrawn(recruit:TestSubject):Void
	{
		resortRequired = true;
	}
	
	function onRecruitSelected(recruit:TestSubject):Void
	{
		if (selectedRecruit != null && selectedRecruit != recruit)
			selectedRecruit.deselect();
		
		selectedRecruit = recruit;
	}
	
	function sortDrawables():Void
	{
		if (resortRequired)
		{
			drawables.sort(sortDrawablesByDepth);
			for (drawable in drawables)
				drawable.artwork.parent.addChild(drawable.artwork);
		}
		Actuate.timer(0.4).onComplete(sortDrawables);
	}
	
	function sortDrawablesByDepth(a:IDrawable, b:IDrawable):Int
	{
		if (a.sortDepth > b.sortDepth)
			return 1;
		if (a.sortDepth < b.sortDepth)
			return -1;
		return 0;
	}
}