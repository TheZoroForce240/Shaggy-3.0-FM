
function onNoteHit(event) 
{
	if (event.noteType == "god") 
	{
		event.healthGain = -1.9;
	}
}
function onPlayerMiss(event)
{
	if (event.noteType == "god")
	{
		event.animCancelled = true;
		event.cancel();
		strumLines.members[event.playerID].deleteNote(event.note);
	}
}

function onNoteCreation(event) 
{
	if (event.note.noteType == "god")
	{
		event.noteSprite = "game/notes/GODNOTE_assets";
		event.note.earlyPressWindow = 0.3;
		event.note.latePressWindow = 0.2;
		event.note.avoid = true;
	}
}

function onPostNoteCreation(event)
{
	if (event.note.noteType == "god")
	{
		event.note.offset.x += 30;
		if (downscroll)
			event.note.offset.y += 65 / (0.7 / event.note.scale.y);
	}
}