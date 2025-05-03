
import flixel.util.FlxGradient;
import flixel.addons.display.FlxBackdrop;

var gradientBar2 = null;
var dtBg = null;
var dtBgBg = null;

function postCreate()
{
	//trace("hi");
	camera._filters = PlayState.instance.camera._filters;

	if (PlayState.SONG.meta.displayName == "Limbo")
	{
		camera.bgColor = 0xFF000000;
	}





	dtBg = new FlxBackdrop(null);
	dtBg.loadGraphic(Paths.image('grid'));

	dtBgBg = new FlxBackdrop(null);
	dtBgBg.x += 20;
	dtBgBg.loadGraphic(Paths.image('grid'));
	dtBgBg.alpha = 0.5;

	insert(1, dtBgBg);
	insert(2, dtBg);

	dtBg.velocity.x += 0.4 * 120.0;
	dtBg.velocity.y += 0.2 * 120.0;

	dtBgBg.velocity.x -= 0.25 * 120.0;
	dtBgBg.velocity.y -= 0.15 * 120.0;

	gradientBar2 = FlxGradient.createGradientFlxSprite(1, 512, [0x00ff0000, 0x55AE59E4, 0xAA19ECFF], 1, 90, true);
	gradientBar2.setGraphicSize(1280, 512);
	gradientBar2.updateHitbox();
	gradientBar2.y = FlxG.height - gradientBar2.height;
	insert(3, gradientBar2);
	gradientBar2.scrollFactor.set(0, 0);
	FlxTween.tween(gradientBar2, {y: gradientBar2.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: 4});

}