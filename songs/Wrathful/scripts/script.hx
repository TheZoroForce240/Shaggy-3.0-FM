

function postCreate()
{
	remove(strumLines.members[3].characters[0]);

	insert(members.indexOf(stage.getSprite("bg")), strumLines.members[3].characters[0]);
	strumLines.members[3].characters[0].x -= 150;
	strumLines.members[3].characters[0].y -= 300;

	remove(strumLines);
	insert(members.indexOf(strumLines.members[3].characters[0])+1, strumLines.members[3]);
	strumLines.members[3].cameras = [camGame];
	for (strum in strumLines.members[3])
	{
		strum.scrollFactor.set(1,1);
		strum.x -= 150;
		strum.y -= 550;
	}
		


	add(strumLines.members[0]);
	add(strumLines.members[1]);
}

