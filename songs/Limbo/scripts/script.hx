import funkin.game.Stage;
import openfl.system.Capabilities;
import funkin.backend.utils.NdllUtil;
import funkin.backend.system.framerate.Framerate;

var doWindowStuff = true;

var curSongState = -1;
var limboStages = [];

function postCreate()
{
	limboStages.push(stage);

	for (i in ["mild", "purple", "mansion"])
	{
		var s = new Stage(i);
		limboStages.push(s);
	}

	for (s in limboStages)
	{
		for (name => spr in s.stageSprites)
		{
			spr.shader = stageColorswap;
			spr.alpha = 0.001;
		}
			
	}

	for (sl in strumLines.members)
		for (char in sl.characters)
			remove(char);

	for (i in 0...4)
	{
		limboStages[i].applyCharStuff(strumLines.members[0].characters[i], "dad", 0);
		limboStages[i].applyCharStuff(strumLines.members[1].characters[i], "boyfriend", 0);
		limboStages[i].applyCharStuff(strumLines.members[2].characters[i], "girlfriend", 0);
	}
	setupTrans();

	setSongStage(0);



	dad.x -= 500;
	dad.y += 1500;

	dad.scrollFactor.set(0.8, 0.8);
	
}

function onSongStart()
{
	FlxTween.tween(dad, {y: dad.y-1500, x: dad.x+500}, Conductor.crochet*0.001*12, {ease: FlxEase.cubeInOut});
}

var glitchShader = null;

function setSongStage(val)
{
	if (curSongState == val)
		return;

	trace(val);

	remove(blackHUDBG);
	

	if (val == 0)
		glitchShader.enabled = 0.0;
	else
		glitchShader.enabled = 1.0;

	curSongState = val;
	for (s in limboStages)
	{
		for (name => spr in s.stageSprites)
			spr.alpha = 0.001;
	}

	for (i in strumLines.members[0].characters)
		i.visible = false;
	for (i in strumLines.members[1].characters)
		i.visible = false;
	for (i in strumLines.members[2].characters)
		i.visible = false;

	for (name => spr in limboStages[val].stageSprites)
		spr.alpha = 1;

	strumLines.members[0].characters[val].visible = true;
	strumLines.members[1].characters[val].visible = true;
	strumLines.members[2].characters[val].visible = true;

	defaultCamZoom = Std.parseFloat(limboStages[val].stageXML.get("zoom"));

	iconP2.setIcon(strumLines.members[0].characters[val].getIcon());

	insert(members.length+1, blackHUDBG);
}

function update(elapsed)
{

	if (curStep >= 3744)
		setSongStage(0);
	else if (curStep >= 3328)
		setSongStage(3);
	else if (curStep >= 3072)
		setSongStage(0);
	else if (curStep >= 2560)
		setSongStage(2);
	else if (curStep >= 2304)
		setSongStage(0);
	else if (curStep >= 1792)
		setSongStage(1);
	else
		setSongStage(0);

}

var limboShader = null;
var fakeBarSpr = null;



var winX = 0;
var winY = 0;

var gameWindow = null;

function setupTrans()
{
	limboShader = new CustomShader("limbo");
	glitchShader = new CustomShader("glitch");
	fakeBarSpr = new FlxSprite();

	limboShader.glitchChance = 0.002;
	limboShader.glitchStrength = 0.05;

	glitchShader.enabled = 0.0;
	glitchShader.flashingLights = 1.0;

	//need specific bars for different dpis
	var barToUse = "1K";
	limboShader.fakeBarHeight = 31*2;

	if (window.display.dpi >= 144) //dont really expect anyone to be using over that amount so yea
	{
		barToUse = "4K";
		limboShader.fakeBarHeight = 45*2;
	}


	fakeBarSpr.loadGraphic(Paths.image("fakeBar"+barToUse));
	fakeBarSpr.alpha = 0.001;
	add(fakeBarSpr);

	limboShader.fakeBar = fakeBarSpr.graphic.bitmap;

	if (doWindowStuff)
	{
		window.fullscreen = false;
		window.borderless = true;
	}






	if (doWindowStuff)
	{
		winX = (Capabilities.screenResolutionX*0.5) - (2560*0.5);
		winY = (Capabilities.screenResolutionY*0.5) - (1440*0.5);
		window.width = 2560;
		window.height = 1440;
		window.x = winX;
		window.y = winY;
		gameWindow = window; //use actual window
		limboShader.zoom = 2.0;
	}
	else
	{
		limboShader.fakeBarHeight = 0;
		gameWindow = new FlxSprite(); //empty sprite object
		limboShader.zoom = 1.5;
	}


	for (d in strumLines.members[0].characters)
		d.shader = glitchShader;

	camGame.addShader(limboShader);
	camHUD.addShader(limboShader);


	if (doWindowStuff)
	{
		#if windows
		NdllUtil.getFunction('ndll-mario', 'set_transparent', 4)(1, 5, 5, 5);
		#end
	}


	Framerate.instance.visible = false;

	
	limboShader.angle = 0.0;
	limboShader.split = 0.0;

	limboShader.y1 = 0.0;
	limboShader.y2 = 0.0;

	sh_r = 60;
}

function destroy()
{
	if (doWindowStuff)
	{
		window.x = (Capabilities.screenResolutionX*0.5) - (1280*0.5);
		window.y = (Capabilities.screenResolutionY*0.5) - (720*0.5);
		window.fullscreen = false;
		window.borderless = false;
		window.width = 1280;
		window.height = 720;
		#if windows
		NdllUtil.getFunction('ndll-mario', 'remove_transparent', 0)();
		#end
	}

	Framerate.instance.visible = true;
}


var iTime = 0.0;
function postUpdate(elapsed)
{
	iTime += elapsed;
	limboShader.iTime = iTime;
	glitchShader.iTime = iTime;

	if (curStep >= 3456)
		sh_r = 600;

	if (!doWindowStuff)
	{
		limboShader.x = gameWindow.x;
		limboShader.y = gameWindow.y;
	}

	if (curSongState == 3)
	{
		var rotRateSh = (Conductor.curBeatFloat*4) / 9.5;

		var x = 0;
		var y = 0;

		y += -Math.sin(rotRateSh * 2) * sh_r * 0.45 * 0.3;
        x -= Math.cos(rotRateSh) * sh_r * 0.3;

		gameWindow.x = winX + x;
        gameWindow.y = winY + y;

        limboShader.angle = Math.sin(rotRateSh) * sh_r * 0.01;
	}

	if (curMeasure >= 270 && curMeasure < 278)
	{
		limboShader.y1 = Math.cos(curBeatFloat*0.5)*0.1;
		limboShader.y2 = -Math.cos(curBeatFloat*0.5)*0.1;
	}
	if (curMeasure >= 278 && curMeasure < 286)
	{
		limboShader.y1 = Math.cos(curBeatFloat*0.5)*0.1;
		limboShader.y2 = -Math.cos(curBeatFloat*0.5)*0.1;

		limboShader.angle = FlxMath.lerp(limboShader.angle, -Math.sin(curBeatFloat*0.25) * 10, elapsed*7);
	}

	if (curMeasure >= 286 && curMeasure < 302)
	{
		limboShader.y1 = Math.cos(curBeatFloat*0.5)*0.1;
		limboShader.y2 = -Math.cos(curBeatFloat*0.5)*0.1;
		limboShader.angle = FlxMath.lerp(limboShader.angle, -Math.sin(curBeatFloat*0.25) * 10, elapsed*7);
		limboShader.split = FlxMath.lerp(limboShader.split, 0.15 + (Math.cos(curBeatFloat*0.35) * 0.05), elapsed*7);
	}
}

function addCameraZoom(g, h)
{
	camGame.zoom += g;
	camHUD.zoom += h;
}


function stepHit()
{

	var sec = Math.floor(curStep/16);
    if (sec >= 4 && sec < 12)
    {
        if (curStep % 16 == 0 || curStep % 16 == 6)
        {
			addCameraZoom(0.05, 0.05);
        }
    }
    else if (sec >= 12 && sec < 16)
    {
        if (curStep % 16 == 0 || curStep % 16 == 6 || curStep % 32 == 30 || curStep % 32 == 28)
        {
            addCameraZoom(0.05, 0.05);
        }
    }
    if ((sec >= 16 && sec < 28) || (sec >= 32 && sec < 40))
    {
        if (curStep % 16 == 0 || curStep % 32 == 20 || curStep % 16 == 6 || curStep % 32 == 30 || curStep % 32 == 28 || curStep % 32 == 26)
        {
            addCameraZoom(0.05, 0.05);
			defaultCamZoom = 0.6;
        }
    }
    else if (sec >= 28 && sec < 32)
    {
        if (curStep % 32 == 0 || curStep % 32 == 6 || curStep % 32 == 12 || curStep % 32 == 18 || curStep % 32 == 24 || curStep % 32 == 26)
        {
            addCameraZoom(0.08, 0.08);
            defaultCamZoom = 0.8;
        }
    }
    else if (sec >= 40 && sec < 48)
        {
            if (curStep % 16 == 0 || curStep % 16 == 6 || curStep % 16 == 12 || curStep % 16 == 14)
            {
				addCameraZoom(0.08, 0.08);
				defaultCamZoom = 0.7;
            }
        }
    else if (sec >= 48 && sec < 64)
    {
        if (curStep % 32 == 0 || curStep % 64 == 48)
        {
			addCameraZoom(0.14, 0.08);
            defaultCamZoom = 0.6;
        }
    }
    else if (sec >= 64 && sec < 80)
    {
        if (curStep % 16 == 0)
        {
			addCameraZoom(0.14, 0.08);
            defaultCamZoom = 0.6;
        }
        if ((curStep % 64 > 48 && curStep % 2 == 0))
        {
			addCameraZoom(0.06, 0.06);
            defaultCamZoom = 0.7;
        }
    }
    else if (sec >= 80 && sec < 96)
    {
        if (curStep % 32 == 0)
        {
			addCameraZoom(0.14, 0.08);
            defaultCamZoom = 0.6;
        }
        if ((curStep % 64 == 48 || curStep % 64 == 56 || curStep % 64 == 58 || curStep % 64 == 60 || curStep % 64 == 62))
        {
			addCameraZoom(0.06, 0.06);
            defaultCamZoom = 0.7;
        }
    }
    else if (sec >= 96 && sec < 112)
    {
        if (curStep % 16 == 0)
        {
			camGame.followLerp = 0.02*2;
			addCameraZoom(0.14, 0.08);
            defaultCamZoom = 1.0;
        }
        if ((curStep % 32 == 4 || curStep % 32 == 6))
        {
			addCameraZoom(0.06, 0.06);
            defaultCamZoom = 0.7;
        }
        if ((curStep % 32 == 18 || curStep % 32 == 20 || curStep % 32 == 22 || curStep % 32 == 24))
        {
			addCameraZoom(0.06, 0.06);
            defaultCamZoom = 0.6;
        }
        if ((curStep % 32 == 28 || curStep % 32 == 29 || curStep % 32 == 30 || curStep % 32 == 31))
        {
			addCameraZoom(0.02, 0.02);
            defaultCamZoom = 0.7;
        }
    }
    else if (sec >= 192 && sec < 208)
    {
        if (curStep % 32 == 0)
        {
            camGame.followLerp = 0.02*1.5;
			addCameraZoom(0.2, 0.08);

			limboShader.angle = FlxG.random.float(-20, 20);
			tweenLimboShader("angle", 0, Conductor.crochet*0.001*4, "cubeOut");

			gameWindow.x = winX + FlxG.random.float(-100, 100);
			gameWindow.y = winY + FlxG.random.float(-100, 100);
			FlxTween.tween(gameWindow, {x: winX, y: winY}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});

			limboShader.glitchChance = 1.0;
			tweenLimboShader("glitchChance", 0.1, Conductor.crochet*0.001*4, "cubeOut");
			
			/*
            game.camHUD.x = FlxG.random.float(-100, 100);
            game.camGame.x = FlxG.random.float(-100, 100);
            game.camHUD.angle = FlxG.random.float(-20, 20);
            game.camGame.angle = FlxG.random.float(-20, 20);
            game.camHUD.y = FlxG.random.float(-100, 100);
            game.camGame.y = FlxG.random.float(-100, 100);
            
            FlxTween.tween(game.camHUD, {angle: 0, x: 0, y: 0}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});
            FlxTween.tween(game.camGame, {angle: 0, x: 0, y: 0}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});
            FlxTween.tween(game.camHUD2, {angle: 0, x: 0, y: 0}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});
            FlxTween.tween(game.camGame2, {angle: 0, x: 0, y: 0}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});
			*/
        }
    }
    if (sec >= 252 && sec < 268)
    {
        if (curStep % 16 == 0)
        {
			addCameraZoom(0.14, 0.08);
            defaultCamZoom = 0.6;

			limboShader.angle = FlxG.random.float(-20, 20);
			gameWindow.x = winX + FlxG.random.float(-100, 100);
			gameWindow.y = winY + FlxG.random.float(-100, 100);
			tweenLimboShader("angle", 0, Conductor.crochet*0.001*4, "cubeOut");
			FlxTween.tween(gameWindow, {x: winX, y: winY}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});

			limboShader.glitchChance = 1.0;
			tweenLimboShader("glitchChance", 0.1, Conductor.crochet*0.001*4, "cubeOut");

			/*
            game.camHUD.x = FlxG.random.float(-100, 100);
            game.camGame.x = FlxG.random.float(-100, 100);
            game.camHUD.angle = FlxG.random.float(-20, 20);
            game.camGame.angle = FlxG.random.float(-20, 20);
            game.camHUD.y = FlxG.random.float(-100, 100);
            game.camGame.y = FlxG.random.float(-100, 100);
            copyCamPos();
            FlxTween.tween(game.camHUD, {angle: 0, x: 0, y: 0}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});
            FlxTween.tween(game.camGame, {angle: 0, x: 0, y: 0}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});
            FlxTween.tween(game.camHUD2, {angle: 0, x: 0, y: 0}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});
            FlxTween.tween(game.camGame2, {angle: 0, x: 0, y: 0}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});
			*/
        }
    }

	
    if (curStep % 16 == 0)
    {
        switch(sec)
        {
            case 152: 
				defaultCamZoom = 1.0;		
			case 252:
				glitchShader.enabled = 1.0;		

            case 268: 

				tweenLimboShader("angle", 10, Conductor.crochet*0.001*4, "linear");
				//tweenLimboShader("split", 0.025, Conductor.crochet*0.001*3, "cubeInOut");
				tweenLimboShader("y2", -0.15, Conductor.crochet*0.001*4, "linear");
                
            case 269: 
				iTime = 0; //idk it looks better for some reason
				limboShader.glitchChance = 0.35;
				dad.playAnim("whatdididotoyouhhuuaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", true);
				tweenLimboShader("y1", 0.1, Conductor.crochet*0.001*4, "expoInOut");
                tweenLimboShader("y2", -0.1, Conductor.crochet*0.001*4, "expoInOut");
				tweenLimboShader("angle", 0, Conductor.crochet*0.001*4, "expoInOut");
				tweenLimboShader("split", 0.15, Conductor.crochet*0.001*4, "expoInOut");
            case 302: 


				tweenLimboShader("y2", 0.0, Conductor.crochet*0.001*12, "cubeInOut");
                tweenLimboShader("y1", 0.0, Conductor.crochet*0.001*12, "cubeInOut");
				tweenLimboShader("angle", 0.0, Conductor.crochet*0.001*12, "cubeInOut");
				tweenLimboShader("split", 0.0, Conductor.crochet*0.001*12, "cubeInOut");
                
            case 305:
				limboShader.glitchChance = 0.0;
                dad.visible = false;
                iconP2.visible = false; 

			case 32:
				limboShader.glitchChance = 0.05;

			case 48:
				glitchShader.enabled = 1.0;
				limboShader.glitchChance = 0.15;

			case 111 | 143 | 159 | 191 | 207 | 233:		
				if (sec == 159)
					defaultCamZoom = 1.5;		
				FlxTween.tween(blackHUDBG, {alpha: 1.0}, Conductor.crochet*0.001*3.5, {ease: FlxEase.cubeIn});
				tweenLimboShader("glitchChance", 0.5, Conductor.crochet*0.001*3.5, "cubeIn");
			case 112 | 144 | 160 | 192 | 208:
				if (sec == 112)
					stageColorswap.hue = 0.205;
				if (sec == 160)
					stageColorswap.hue = -0.1;
				if (sec == 208)
					stageColorswap.hue = 0.6;
				if (sec == 160 || sec == 144)
				{
					tweenLimboShader("angle", 0, Conductor.crochet*0.001*16, "cubeOut");
					FlxTween.tween(gameWindow, {x: winX, y: winY}, Conductor.crochet*0.001*16, {ease: FlxEase.cubeOut});
				}

				trace("fade out");
				FlxTween.tween(blackHUDBG, {alpha: 0.0}, Conductor.crochet*0.001*4, {ease: FlxEase.cubeOut});
				tweenLimboShader("glitchChance", 0.1, Conductor.crochet*0.001*4, "cubeOut");
			case 234:
				stageColorswap.hue = 0.0;
				limboShader.glitchChance = 0.02;
				FlxTween.tween(blackHUDBG, {alpha: 0.0}, Conductor.crochet*0.001*24, {ease: FlxEase.cubeOut});
				FlxTween.tween(gameWindow, {x: winX, y: winY}, Conductor.crochet*0.001*16, {ease: FlxEase.cubeOut});
				tweenLimboShader("angle", 0, Conductor.crochet*0.001*16, "cubeOut");
        }
    }


	if (curStep == 1951 || curStep == 1963 || curStep == 1980 || curStep == 1982 || curStep == 2079 || curStep == 2097 || curStep == 2111 || curStep == 2127 || curStep == 2159)
	{
		limboShader.angle = FlxG.random.float(-10, 10);
		gameWindow.x = winX + FlxG.random.float(-100, 100);
		gameWindow.y = winY + FlxG.random.float(-100, 100);
	}
}

public function tweenLimboShader(prop:String, value:Float, time:Float, ease:String)
{

	var s = limboShader;
	if (s != null)
	{
		var easeFunc = CoolUtil.flxeaseFromString(ease, "");

		var shit = Reflect.getProperty(s.data, prop);

		var v:Float = value; //it doesnt like the arg for some reason
		var startVal = Reflect.getProperty(shit, "value")[0]; //get value dynamically

		FlxTween.num(startVal, v, time, {onUpdate: function(tween:FlxTween){
			var ting = FlxMath.lerp(startVal, v, easeFunc(tween.percent)); //ease properly with lerp
			Reflect.setProperty(shit, "value", [ting]);
		}, ease: easeFunc, onComplete: function(tween:FlxTween) {
			Reflect.setProperty(shit, "value", [v]);
		}});
	}
}


function onNoteHit(event)
{
	if (event.note.strumLine.ID == 0)
	{
		if (curMeasure >= 160 && curMeasure < 192)
		{
			switch(event.note.strumID)
			{
				case 0:
					gameWindow.x = winX + FlxG.random.float(-25, 25);
				case 1: 
					camGame.zoom = FlxG.random.float(0.55, 1.4);
				case 2: 
					gameWindow.y = winY + FlxG.random.float(-25, 25);
				case 3: 
					limboShader.angle = FlxG.random.float(-10, 10);
			}
		}
	}
}