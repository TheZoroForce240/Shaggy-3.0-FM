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
	if (event.noteType == "death") 
	{
		event.healthGain = -1.9;
	}
}
function onPlayerMiss(event)
{
	if (event.noteType == "death")
	{
		event.animCancelled = true;
		event.cancel();
		strumLines.members[event.playerID].deleteNote(event.note);
	}
}

function onNoteCreation(event) 
{
	if (event.note.noteType == "death")
	{
		event.noteSprite = "game/notes/DEATHNOTE_assets";
		event.note.earlyPressWindow = 0.3;
		event.note.latePressWindow = 0.2;
		event.note.avoid = true;
	}
}

function onPostNoteCreation(event)
{
	if (event.note.noteType == "death")
	{
		if (downscroll)
			event.note.offset.y += -15 / (0.7 / event.note.scale.y);
		else
			event.note.offset.y += 65 / (0.7 / event.note.scale.y);
		
		event.note.scale.x *= 0.86;
		event.note.scale.y *= 0.86;

		//event.note.updateHitbox();
	}
}