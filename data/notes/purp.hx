
function onNoteHit(event) 
{
	if (event.noteType == "purp") 
	{
		event.healthGain = -0.35;
	}
}
function onPlayerMiss(event)
{
	if (event.noteType == "purp")
	{
		event.animCancelled = true;
		event.cancel();
		strumLines.members[event.playerID].deleteNote(event.note);
	}
}

function onNoteCreation(event) 
{
	if (event.note.noteType == "purp")
	{
		event.noteSprite = "game/notes/PURPNOTE_assets";
		event.note.earlyPressWindow = 0.5;
		event.note.latePressWindow = 0.2;
		event.note.avoid = true;
	}
}

function onPostNoteCreation(event)
{
	if (event.note.noteType == "purp")
	{
		if (downscroll)
			event.note.offset.y -= 90 / (0.7 / event.note.scale.y);
		else
			event.note.offset.y += 25 / (0.7 / event.note.scale.y);

		event.note.scale.x *= 0.95;
		event.note.scale.y *= 0.95;

		//event.note.updateHitbox();
	}
}