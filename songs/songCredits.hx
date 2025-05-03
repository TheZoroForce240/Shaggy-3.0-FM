import flixel.text.FlxText.FlxTextBorderStyle;

var songPopup = null;
var popupText = null;

public var camOther:HudCamera;

function postCreate()
{
	FlxG.cameras.add(camOther = new HudCamera(), false);
	camOther.bgColor = 0x0000000;
	camOther._filters = PlayState.instance.camera._filters;

	songPopup = new FlxSprite(-40,90).loadGraphic(Paths.image('Slider'));
	songPopup.cameras = [camOther];
	songPopup.alpha = -40;
	songPopup.setGraphicSize(500, 150);
	songPopup.updateHitbox();
	songPopup.x -= songPopup.width;
	songPopup.y = 200;
	add(songPopup);
	


	var composer:String = "";
	switch(curSong)
	{
		case "where are you" | "eruption" | "kaio ken" | "whats new" | "blast" | "super saiyan" | "god eater" | "soothing power" | "astral calamity"| "ultra instinct" | "talladega":
			composer = "srPerez";
		case "big shot": 
			composer = "Toby Fox     Vocals: srPerez";
		case "thunderstorm": 
			composer = "Saruky";
		case "dissasembler":
			composer = "Joan Atlas";
		case "mild mania" | "mild mania old" | "mild mania erect" | "purple power" | "purple power erect"| "trickster" | "trickster erect" | "limbo" | "potentiality"| "wrathful": 
			composer = "GalaxyGodDamian";
		case "vain" | "surge": 
			composer = "Spurk";
		case "fushiginachikara":
			 composer = "Lord Voiid";
		case "instinct":
			composer = "Armando The Anima";
		case "revolving": 
			composer = "Toby Fox     Vocals: Fallnnn";
	}

	var formattedSong = SONG.meta.displayName;

	var popText = "" + formattedSong + "\nComposer: " + composer;

	popupText = new FlxText(songPopup.x, songPopup.y + 20, songPopup.width-50, popText, 20);
	popupText.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	popupText.scrollFactor.set();
	popupText.borderSize = 1.25;

	popupText.offset.set(0, 0);
	popupText.cameras = [camOther];
	add(popupText);
}

function onSongStart()
{
	FlxTween.tween(songPopup, {alpha: 0.9, x: 0}, 0.5, {ease: FlxEase.expoInOut});
	FlxTween.tween(popupText, {alpha: 0.9, x: 0}, 0.5, {ease: FlxEase.expoInOut});

	new FlxTimer().start(2.5, function(tmr:FlxTimer)
	{
		FlxTween.tween(songPopup, {x: 0 - songPopup.width}, 0.5, {
			onComplete: function(twn:FlxTween) {
				remove(songPopup);
				songPopup.kill();
				remove(popupText);
			},
			onUpdate: function(twn:FlxTween) {
				popupText.x = songPopup.x;
			},
		ease: FlxEase.quartIn});
	});
}