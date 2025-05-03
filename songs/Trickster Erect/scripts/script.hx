

function postCreate()
{
	switchCharacter(0, 0);
}

function stepHit()
{
	if (curMeasure == 64 && curStep % 16 == 0)
	{
		FlxG.camera.flash(0xFFFF0000, 1);
		switchCharacter(0, 1);
	}
}