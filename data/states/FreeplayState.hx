import String;
import flixel.util.FlxGradient;

var wbSongs:Array<String> = ['astral calamity', 'potentiality'];
var shSongs:Array<String> = ['where are you', 'eruption', 'kaio ken', 'whats new', 'blast', 'instinct', 'ultra instinct', 'surge', 'super saiyan', 'god eater'];
var trickySongs:Array<String> = ['trickster', 'trickster erect']; //songs and stuff
var redSongs:Array<String> = ['mild mania', 'mild mania erect', 'mild mania old', 'soothing power', 'thunderstorm','wrathful','dissasembler'];
var purpSongs:Array<String> = ['double god gateway', 'vain', 'spark', 'fushiginachikara', 'purple power','purple power erect', 'revolving'];
var purp2Songs:Array<String> = ['purple power erect'];
var limbo:Array<String> = ['limbo'];
var menuBGs:Array<FlxSprite> = []; //store sprites
var bgSongListThing = [redSongs, purpSongs, purp2Songs, limbo, trickySongs, shSongs, wbSongs]; //trying to simplify it or something
var selectedBG:Int = 0;

var gradientBar = null;

function postCreate()
{
	var bgList = ['red', 'purple', 'purple2', 'limbo', 'tricky', 'sh', 'wb'];
	for (i in 0...bgList.length) //load bgs and shit
	{
		var menuBG = new FlxSprite().loadGraphic(Paths.image('menus/freeplayBGs/' + bgList[i]));
		menuBG.setGraphicSize(1280, 720);
		menuBG.updateHitbox();
		menuBG.screenCenter();
		insert(members.indexOf(bg)+1, menuBG);
		menuBG.antialiasing = true;
		menuBGs.push(menuBG);
		menuBG.alpha = 0.0;
	}

	gradientBar = FlxGradient.createGradientFlxSprite(1, 512, [0x00ff0000, 0x55AE59E4, 0xAA19ECFF], 1, 90, true);
	gradientBar.setGraphicSize(1280, 512);
	gradientBar.updateHitbox();
	gradientBar.y = FlxG.height - gradientBar.height;
	FlxTween.tween(gradientBar, {y: gradientBar.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: 4});
	add(gradientBar);
	gradientBar.scrollFactor.set(0, 0);
}

function update(elapsed)
{

	var doesHaveSong:Bool = false;
	for (i in 0...bgSongListThing.length)
	{
		if (bgSongListThing[i].contains(songs[curSelected].name.toLowerCase()))
		{
			selectedBG = i; //get bg shit idk
			doesHaveSong = true;
		}
	}
	if (!doesHaveSong)
		selectedBG = -1;

	for (i in 0...menuBGs.length)
	{
		var spr = menuBGs[i];
		if (i == selectedBG)
		{
			if (spr.alpha < 1)
				spr.alpha += elapsed*120 * 0.03;
			else 
				spr.alpha = 1;
		}
		else
		{
			if (spr.alpha > 0)
				spr.alpha -= elapsed*120 * 0.03;
			else 
				spr.alpha = 0;
		}
	}
	if (selectedBG == -1) //backup to regular bg if no song is found
	{
		if (bg.alpha < 1)
			bg.alpha += elapsed*120 * 0.03;
		else 
			bg.alpha = 1;
	}
	else
	{
		if (bg.alpha > 0)
			bg.alpha -= elapsed*120 * 0.03;
		else 
			bg.alpha = 0;
	}
}
function onChangeSelection(e)
{

}