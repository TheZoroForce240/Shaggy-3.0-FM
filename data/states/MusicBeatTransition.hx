

function update(elapsed)
{
	if (PlayState.instance != null)
		transitionCamera._filters = PlayState.instance.camera._filters;
}