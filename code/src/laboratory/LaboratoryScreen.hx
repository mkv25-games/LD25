package laboratory;

import com.eclecticdesignstudio.motion.Actuate;
import core.interfaces.IDrawable;
import core.Screen;
import core.Signal;
import game.Global;
import laboratory.rewards.RewardScreens;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Vector;

class LaboratoryScreen extends Screen
{
	@global var scores:Scores;
	@global var rooms:Rooms;	
	@global var humanResources:HumanResources;
	@global var rewardScreens:RewardScreens;
	
	public var layerPeople:Sprite;
	public var layerDecals:Sprite;
	
	public var ready:Signal;
	
	public var resortRequired:Bool;
	public var drawables:Vector<IDrawable>;
	
	
	var selectedRecruit:TestSubject;
	
	public function new() 
	{
		scores = Global.scores;
		rooms = Global.rooms;
		humanResources = Global.humanResources;
		rewardScreens = Global.rewardScreens;
		
		super();
		
		layerPeople = new Sprite();
		layerDecals = new Sprite();
		
		ready = new Signal();
		
		screen.bitmapData = Assets.getBitmapData("assets/laboratory.png");
		drawables = new Vector<IDrawable>();
		
		addChild(screen);
		addChild(scores);
		addChild(rooms);
		addChild(layerPeople);
		addChild(layerDecals);
		addChild(rewardScreens);
		
		humanResources.recruitArrived.add(onRecruitArrived);
		humanResources.recruitDied.add(onRecruitDied);
		
		visible = false;
		resortRequired = true;
		
		sortDrawables();
	}
	
	public function show(?args:Dynamic):Void
	{
		visible = true;
		this.alpha = 0.0;
		Actuate.tween(this, 2.0, { alpha: 1.0 } ).onComplete(onShowComplete).delay(1.0);
		
		requestFocus.dispatch(this);
		
		scores.employeeScore.setValue(0);
		scores.deathScore.setValue(0);
		scores.researchScore.setValue(0);
		scores.moneyScore.setValue(0);
	}
	
	function onShowComplete():Void
	{
		ready.dispatch(this);
		
		rooms.flashAllRooms();
		
		// set starting values		
		scores.employeeScore.changeValue(humanResources.testSubjects.length);
		scores.deathScore.changeValue(0);
		scores.researchScore.changeValue(0);
		scores.moneyScore.changeValue(1000);
		
		// recruit the initial test subjects
		for (i in 0...5)
		{
			Actuate.timer(i * 0.15).onComplete(humanResources.recruitTestSubject);
		}
		
		rewardScreens.showImage(RewardScreens.RS01_EMPLOYEES);
	}
	
	function onRecruitArrived(hr:HumanResources):Void
	{
		var recruit = hr.newestRecruit();
		moveRecruitToRoom(recruit, rooms.waitingRoom);
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
		
		scores.employeeScore.changeValue(humanResources.testSubjects.length);
		scores.moneyScore.subtract(100);
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
		
		if (recruit.room != null)
		{
			recruit.room.employeeRemoved(recruit);
			recruit.room = null;
		}
		
		Actuate.timer(1.0).onComplete(moveRecruitToRecycling, [recruit]);
		
		scores.employeeScore.changeValue(humanResources.testSubjects.length);
		scores.deathScore.changeValue(humanResources.deadRecruits.length);
	}
	
	function onRecruitPickedUp(recruit:TestSubject):Void
	{
		addChild(recruit);
		
		if (recruit.room != null)
		{
			recruit.room.employeeRemoved(recruit);
			recruit.room = null;
		}
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
				recruit.target.x = recruit.x;
				recruit.target.y = recruit.y;
				moveRecruitToRoom(recruit, room);
				return;
			}
		}
		
		moveRecruitToRoom(recruit, rooms.waitingRoom);
	}
	
	function moveRecruitToRecycling(recruit:TestSubject):Void
	{
		moveRecruitToRoom(recruit, rooms.recyclingRoom);
		rooms.recyclingRoom.assignRandomWithinBounds(recruit.target); 
		recruit.x = recruit.target.x;
		recruit.y = recruit.target.y;
		
		Actuate.timer(35).onComplete(recruit.fadeOut);
	}
	
	function moveRecruitToRoom(recruit:TestSubject, room:Room):Void
	{
		if (recruit.room != null)
		{
			recruit.room.employeeRemoved(recruit);
			recruit.room = null;
		}
		recruit.room = room;
		room.employeeAdded(recruit);
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