
import flixel.util.FlxGradient;
var optionList:Array<String> = ['storymode', 'freeplay', 'credits', 'options', 'lore', 'awards'];
var positions:Array<Array<Float>> = [ [20, 30], [100, 230], [180, 470], [300, 600], [1000, 10], [900, 450]];


var gradientBar:FlxSprite;
var gradientBar2:FlxSprite;

var newMenuItems = [];

function create()
{
	optionShit = ['freeplay','freeplay','freeplay','freeplay','freeplay','freeplay'];
}

function postCreate()
{
	optionShit = ['story mode','freeplay','donate','options','options','options'];
	menuItems.visible = false;

	var port:FlxSprite = new FlxSprite(0, 0);
	port.loadGraphic(Paths.image("menus/mainmenu/ports/"+FlxG.random.int(0, 1)));
	port.setGraphicSize(1280);
	port.updateHitbox();
	port.screenCenter();
	port.antialiasing = true;
	port.scrollFactor.set();
	add(port);


	gradientBar2 = FlxGradient.createGradientFlxSprite(1, 512, [0x00ff0000, 0x55AE59E4, 0xAA19ECFF], 1, 90, true);
	gradientBar2.setGraphicSize(1280, 512);
	gradientBar2.updateHitbox();
	gradientBar2.y = FlxG.height - gradientBar2.height;
	add(gradientBar2);
	gradientBar2.scrollFactor.set(0, 0);
	FlxTween.tween(gradientBar2, {y: gradientBar2.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: 4});
	FlxTween.tween(port, {y: port.y + 50}, 5, {ease: FlxEase.quadInOut, type: 4});


	for (i in 0...optionList.length)
	{
		var offset:Float = 108 - (Math.max(optionList.length, 4) - 4) * 80;
		var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
		menuItem.frames = Paths.getSparrowAtlas('menus/mainmenu/menu_' + optionList[i]);
		menuItem.animation.addByPrefix('idle', optionList[i] + " basic0", 24);
		menuItem.animation.addByPrefix('selected', optionList[i] + "0", 24);
		menuItem.animation.play('idle');
		menuItem.ID = i;
		//menuItem.screenCenter(X);
		//menuItem.x += 150;
		add(menuItem);
		menuItem.alpha = 0.5;
		newMenuItems.push(menuItem);
		//var scr:Float = (optionShit.length - 4) * 0.135;
		//if(optionShit.length < 6) scr = 0;
		menuItem.scrollFactor.set(0, 0);
		menuItem.antialiasing = true;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.8));
		menuItem.updateHitbox();
		menuItem.x = positions[i][0];
		menuItem.y = positions[i][1];
	}

	FlxG.camera.follow(null, null, 0.06);

	changeItem(0);

	var shit = members[4];
	remove(shit);
	insert(members.length+1, shit);
}

function onChangeItem(event)
{
	if (newMenuItems[curSelected] != null)
	{
		newMenuItems[curSelected].alpha = 0.5;
		newMenuItems[curSelected].animation.play('idle');
	}
	if (newMenuItems[event.value] != null)
	{
		newMenuItems[event.value].alpha = 1.0;
		newMenuItems[event.value].animation.play('selected');
	}
}

function postUpdate(elapsed)
{
	for (i in 0...newMenuItems.length)
	{
		newMenuItems[i].visible = menuItems.members[i].visible;
		//newMenuItems[i].alpha = menuItems.members[i].alpha;
	}
}