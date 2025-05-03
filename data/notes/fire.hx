import funkin.backend.scripting.Script;

function create()
{
	//var path = Script.curScript.path;

	//trace(scripts.scripts);

	////var thisScript = scripts.getByPath(path);
	//scripts.remove(thisScript);

}
function onNoteHit(event) 
{
	if (event.noteType == "fire") 
	{
		event.healthGain = -0.35;
	}
}
function onPlayerMiss(event)
{
	if (event.noteType == "fire")
	{
		event.animCancelled = true;
		event.cancel();
		strumLines.members[event.playerID].deleteNote(event.note);
	}
}

function onNoteCreation(event) 
{
	if (event.note.noteType == "fire")
	{
		event.noteSprite = "game/notes/FIRENOTE_assets";
		event.note.earlyPressWindow = 0.5;
		event.note.latePressWindow = 0.2;
		event.note.avoid = true;
	}
}

function onPostNoteCreation(event)
{
	if (event.note.noteType == "fire")
	{
		if (downscroll)
			event.note.offset.y -= 185 / (0.7 / event.note.scale.y);
		else
			event.note.offset.y += 62 / (0.7 / event.note.scale.y);

		event.note.scale.x *= 0.86;
		event.note.scale.y *= 0.86;

		//event.note.updateHitbox();
	}
}