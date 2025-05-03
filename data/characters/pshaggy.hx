


public static var sh_r = 600;

var legs = null;

var targetX = 0;
var targetY = 0;

function create()
{
	legs = new FlxSprite(-850, -850);
	legs.frames = Paths.getSparrowAtlas('characters/pshaggy');
	legs.animation.addByPrefix('legs', "solo_legs", 30);
	legs.animation.play('legs');
	legs.antialiasing = true;
	legs.updateHitbox();
	legs.offset.set(legs.frameWidth / 2, 10);
	legs.alpha = 0;
}

function postCreate()
{
	targetX = x;
	targetY = y;
}

var addedLegs = false;

function update(elapsed)
{
	if (!addedLegs)
	{
		addedLegs = true;
		PlayState.instance.insert(PlayState.instance.members.indexOf(this), legs);
	}
	var rotRateSh = (Conductor.curBeatFloat*4) / 9.5;

	var sh_toy = targetX + -Math.sin(rotRateSh * 2) * sh_r * 0.45;
	var sh_tox = targetY - Math.cos(rotRateSh) * sh_r;

	x += (sh_tox - x) / 12;
	y += (sh_toy - y) / 12;

	legs.visible = visible;

	if (animation.name == 'idle')
	{
		var pene = 0.07;
		angle = Math.sin(rotRateSh) * sh_r * pene / 4;

		legs.alpha = 1 * alpha;
		legs.angle = Math.sin(rotRateSh) * sh_r * pene;// + Math.cos(curStep) * 5;

		legs.x = x + 120 + Math.cos((legs.angle + 90) * (Math.PI/180)) * 150;
		legs.y = y + 300 + Math.sin((legs.angle + 90) * (Math.PI/180)) * 150;
	}
	else
	{
		angle = 0;
		legs.alpha = 0;
	}


}

	
function destroy()
{

}