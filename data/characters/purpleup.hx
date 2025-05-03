

var targetX = 0;
var targetY = 0;

var count = 0;

function update(elapsed)
{
    
    count = count + (120*elapsed);
	var what = count / 6;
    //x += 100*elapsed;

    x = targetX - Math.cos(what / 3) * 20;
    y = targetY - Math.cos(what / 5) * 40;
}


function postCreate()
{
    targetX = x;
    targetY = y;
    if (PlayState.instance.curStage == "lava")
    {
        targetY -= 400;
    }
}