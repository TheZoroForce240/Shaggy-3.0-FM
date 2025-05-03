import funkin.backend.scripting.events.StrumCreationEvent;
import funkin.backend.scripting.Script;
//noteskin
function onStrumCreation(event) 
{
	if (event.sprite == "game/notes/default")
		event.sprite = "game/notes/shaggy3";
}
function onNoteCreation(event) 
{
	if (event.noteSprite == "game/notes/default")
		event.noteSprite = "game/notes/shaggy3";
}

public var blackHUDBG = null;
public var stageColorswap = null;

var curCharacterList = [];


function create()
{
	allowGitaroo = false;


	importScript("data/scripts/multikey.hx");

	blackHUDBG = new FlxSprite(0,0);
	blackHUDBG.makeGraphic(1,1,0xFF000000);
	blackHUDBG.setGraphicSize(3000,3000);
	blackHUDBG.scrollFactor.set();
	blackHUDBG.updateHitbox();
	blackHUDBG.screenCenter();
	blackHUDBG.alpha = 0;

	stageColorswap = new CustomShader("colorswap");
	stageColorswap.hue = 0.0;
	stageColorswap.sat = 0;
	stageColorswap.brt = 0;

	for (i in 0...SONG.strumLines.length)
		curCharacterList.push(0);
}

//note cam movement
var animOffsets = ["singLEFT" => [-15, 0], "singDOWN" => [0, 15], "singUP" => [0, -15], "singRIGHT" => [15, 0]];
function updateOffset() 
{
	camGame.targetOffset.set();
	if (strumLines.members[curCameraTarget] != null)
		for (character in strumLines.members[curCameraTarget].characters)
			if (character.animation.curAnim != null)
				if (animOffsets.exists(character.animation.curAnim.name))
					{ 
						camGame.targetOffset.x += animOffsets.get(character.animation.curAnim.name)[0] / strumLines.members[curCameraTarget].characters.length;
						camGame.targetOffset.y += animOffsets.get(character.animation.curAnim.name)[1] / strumLines.members[curCameraTarget].characters.length; 
					}
}
function onNoteHit(event) updateOffset(); function beatHit() updateOffset();


public var healthBarStyle = "healthBarYea";
public var healthBarInner = null;



function postCreate()
{

	insert(members.length+1, blackHUDBG);

	healthBar.visible = false;

	healthBarBG.y -= 20;

	if (curSong == "limbo")
	{
		healthBarStyle = "healthBarLimbo";
		healthBarBG.y -= 45;
	}
		


	healthBarInner = new FlxSprite(healthBarBG.x, healthBarBG.y);
	healthBarInner.loadGraphic(Paths.image(healthBarStyle+"Inner"));


	healthBarInner.cameras = healthBar.cameras;
	healthBarInner.antialiasing = true;
	insert(members.indexOf(healthBarBG),healthBarInner);

	healthBarBG.loadGraphic(Paths.image(healthBarStyle));
	healthBarBG.antialiasing = true;

	if (curSong == "limbo")
	{
		healthBarInner.scale.set(0.15,0.15);
		healthBarBG.scale.set(0.15,0.15);
		healthBarInner.updateHitbox();
		healthBarBG.updateHitbox();

		healthBar.setGraphicSize(healthBarBG.width);
		healthBar.updateHitbox();
		healthBar.screenCenter(FlxAxes.X);
	}
		

	healthBarBG.screenCenter(FlxAxes.X);
	healthBarInner.screenCenter(FlxAxes.X);

	healthBarInner.color = strumLines.members[curCameraTarget].characters[0].iconColor;	


	for (name => spr in stage.stageSprites)
		spr.shader = stageColorswap;
}
function update(elapsed)
{

}




function onEvent(e)
{
	if (e.event.name == "Camera Movement")
		FlxTween.color(healthBarInner, Conductor.crochet*0.001*2, healthBarInner.color, strumLines.members[e.event.params[0]].characters[curCharacterList[e.event.params[0]]].iconColor, {ease: FlxEase.cubeOut});
	else if (e.event.name == "Alt Animation Toggle")
		e.event.params[1] = true; //force on idle for back compat
}


function onStartCountdown()
{
	FlxG.camera.flash(FlxColor.BLACK, 4);
}


public function switchCharacter(strumLineID, charID)
{
	for (char in strumLines.members[strumLineID].characters)
		char.visible = false;

	curCharacterList[strumLineID] = charID;

	strumLines.members[strumLineID].characters[charID].visible = true;
	if (strumLineID == 0)
		iconP2.setIcon(strumLines.members[strumLineID].characters[charID].getIcon());
	else if (strumLineID == 1)
		iconP1.setIcon(strumLines.members[strumLineID].characters[charID].getIcon());
}