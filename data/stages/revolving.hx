var objs:Array<Dynamic> = [];

var eye:Array<Float> = [0, 0, -1, 0];
var lookAt:Array<Float> = [0, 0, 1, 0];
var up:Array<Float> = [0, 1, 0, 0];

var fov = 90 * (Math.PI/180);
//https://github.com/openfl/openfl/blob/develop/src/openfl/geom/PerspectiveProjection.hx
var focalLength = 1.0 * (1.0 / Math.tan(fov * 0.5));
var perspectiveMatrix:Array<Float> = 
[
    focalLength, 0, 0, 0,
	0, focalLength, 0, 0,
	0, 0, 1.0, 1.0,
	0, 0, 0, 0
];
var viewMatrix:Array<Float> = [];

var right:Array<Float> = [1, 0, 0, 0];
var upv:Array<Float> = [0, 1, 0, 0];
var forward:Array<Float> = [0, 0, 1, 0];

function updateViewMatrix()
{
    forward = [(lookAt[0] - eye[0]), (-lookAt[1] - -eye[1]), (lookAt[2] - eye[2]), 0];
    forward = normalize(forward);

    right = cross(up, forward);
	right = normalize(right);
    upv = cross(forward, right);
    var negEye = [-eye[0], eye[1], -eye[2], -eye[3]];
    viewMatrix = 
	[
		right[0], upv[0], forward[0], 0,
		right[1], upv[1], forward[1], 0,
		right[2], upv[2], forward[2], 0,
		dot(right, negEye), dot(upv, negEye), dot(forward, negEye), 1
    ];


    for (i in 0...objs.length)
    {
        var shader:CustomShader = objs[i][1];
        shader.viewMatrix = viewMatrix;
		shader.zoomScale = camGame.zoom / 0.56;
    }
}
function normalize(vec:Array<Float>)
{
	var mag:Float = Math.sqrt((vec[0] * vec[0]) + (vec[1] * vec[1]) + (vec[2] * vec[2]) + (vec[3] * vec[3]) );
	vec[0] = vec[0] / mag;
	vec[1] = vec[1] / mag;
	vec[2] = vec[2] / mag;
	vec[3] = vec[3] / mag;
    return vec;
}
function cross(vec1:Array<Float>, vec2:Array<Float>)
{
	var vec:Array<Float> = [0, 0, 0, 1];
	vec[0] = vec1[1] * vec2[2] - vec1[2] * vec2[1];
	vec[1] = vec1[2] * vec2[0] - vec1[0] * vec2[2];
	vec[2] = vec1[0] * vec2[1] - vec1[1] * vec2[0];
	return vec;
}
function dot(vec1:Array<Float>, vec2:Array<Float>)
{
    return vec1[0] * vec2[0] + vec1[1] * vec2[1] + vec1[2] * vec2[2];
}

var floorSprites = [];
var ceilingSprites = [];
var lowerCenterSprites = [];
var upperCenterSprites = [];

var colors = [0xFF040274, 0xFF24225c];

var bg = null;
var bgShader = null;

function postCreate()
{
	bgShader = new CustomShader("stretch");
	bg = new FlxSprite();
	bg.loadGraphic(Paths.image("stages/jevilBG"));
	bg.scrollFactor.set(0,0);
	bg.scale.set(4, 4);
	bg.updateHitbox();
	bg.color = 0xFF1E1D3B;
	bg.screenCenter();
	bg.shader = bgShader;
	

	//040274
	//24225c
	
	var rad = (Math.PI/180);
	for (i in 0...8)
	{
		{
			var spr = new FlxSprite(400, 800);
			spr.makeGraphic(1,1);
			spr.color = colors[i%2];
			var shader = applyPerspectiveToObj(spr, 1500.0);
			spr.forceIsOnScreen = true;
			floorSprites.push(spr);
			insert(0, spr);
		}
		{
			var spr = new FlxSprite(400, -800);
			spr.makeGraphic(1,1);
			spr.color = colors[i%2];
			var shader = applyPerspectiveToObj(spr, 1500.0);
			spr.forceIsOnScreen = true;
			ceilingSprites.push(spr);
			insert(0, spr);
		}
		{
			var spr = new FlxSprite(400, 0);
			spr.makeGraphic(1,1);
			spr.color = colors[i%2];
			var shader = applyPerspectiveToObj(spr, 1500.0);
			spr.forceIsOnScreen = true;
			lowerCenterSprites.push(spr);
			insert(members.indexOf(gf), spr);
		}
		{
			var spr = new FlxSprite(400, 0);
			spr.makeGraphic(1,1);
			spr.color = colors[i%2];
			var shader = applyPerspectiveToObj(spr, 1500.0);
			spr.forceIsOnScreen = true;
			upperCenterSprites.push(spr);
			insert(members.indexOf(gf), spr);
		}

	}

	insert(0, bg);

	if (dad != null)
    	applyPerspectiveToObj(dad, 0.0);
	if (gf != null)
	{
		applyPerspectiveToObj(gf, 200.0);
	}

	if (boyfriend != null)
    	applyPerspectiveToObj(boyfriend, 0.0);
}

function applyPerspectiveToObj(spr:FlxSprite, z:Float)
{
    var shader = new CustomShader("perspective");

    shader.data.vertexXOffset.value = [0.0, 0.0, 0.0, 0.0];
    shader.data.vertexYOffset.value = [0.0, 0.0, 0.0, 0.0];
    shader.data.vertexZOffset.value = [0.0, 0.0, 0.0, 0.0];
    shader.perspectiveMatrix = perspectiveMatrix;
    shader.zOffset = z;
    spr.shader = shader;    
   

    objs.push([spr, shader]);
    return shader;
}

var s = 0.0;
var d = 0.0;
function postUpdate(elapsed)
{

    var debugCam = false;

    if (debugCam)
    {
        player.cpu = true;
        PlayState.instance.camFollow.x = 640;
        PlayState.instance.camFollow.y = 720/2;
        camGame.targetOffset.x = 0.0;
        camGame.targetOffset.y = 0.0;

        lookAt[0] = Math.sin(s);
        lookAt[1] = Math.sin(d);
        lookAt[2] = Math.cos(s) * Math.cos(d);

        if (FlxG.keys.pressed.LEFT)
            s -= elapsed;
        if (FlxG.keys.pressed.RIGHT)
            s += elapsed;
        if (FlxG.keys.pressed.UP)
            d += elapsed;
        if (FlxG.keys.pressed.DOWN)
            d -= elapsed;

        if (FlxG.keys.pressed.A || FlxG.keys.pressed.D)
        {
            var strafe = normalize(cross(lookAt, up));
            var shit = -1;
            if (FlxG.keys.pressed.A)
                shit = 1;

            eye[0] = eye[0] + elapsed*strafe[0]*shit;
            eye[1] = eye[1] + elapsed*strafe[1]*shit;
            eye[2] = eye[2] + elapsed*strafe[2]*shit;

        }

        if (FlxG.keys.pressed.W || FlxG.keys.pressed.S)
        {
            var shit = -1;
            if (FlxG.keys.pressed.W)
                shit = 1;

            eye[0] = eye[0] + elapsed*lookAt[0]*shit;
            eye[1] = eye[1] + elapsed*lookAt[1]*shit;
            eye[2] = eye[2] + elapsed*lookAt[2]*shit;

        }

        lookAt[0] = eye[0] + lookAt[0];
        lookAt[1] = eye[1] + lookAt[1];
        lookAt[2] = eye[2] + lookAt[2];
    }

    updateViewMatrix();

	updateShit(elapsed);
}


var time = 0.0;

function updateShit(elapsed)
{
	time += elapsed;



	

	var rad = (Math.PI/180);

	var angle = time / rad;

	bgShader.iTime = time * 0.2;

	for (i in 0...8)
	{
		{
			var spr = floorSprites[i];

			var a = angle % 45;

			if (angle % 90 >= 45)
				spr.color = colors[(i+1)%2];
			else
				spr.color = colors[i%2];

			var ang1 = ((i*45) + a) * rad;
			var ang2 = (((i+1)*45)+a) * rad;
	
			var size = 2500;
	
			var shader = spr.shader;
	
			shader.data.vertexXOffset.value = [0.0, 0.0, Math.cos(ang1)*size, Math.cos(ang2)*size];
			shader.data.vertexYOffset.value = [0.0, 0.0, 0.0, 0.0];
			shader.data.vertexZOffset.value = [0.0, 0.0, Math.sin(ang1)*size, Math.sin(ang2)*size];
		}
		{
			var spr = ceilingSprites[i];

			var a = angle % 45;

			if (angle % 90 >= 45)
				spr.color = colors[(i+1)%2];
			else
				spr.color = colors[i%2];

			var ang1 = ((i*45) + a) * rad;
			var ang2 = (((i+1)*45)+a) * rad;
	
			var size = 2500;
	
			var shader = spr.shader;
	
			shader.data.vertexXOffset.value = [0.0, 0.0, Math.cos(ang1)*size, Math.cos(ang2)*size];
			shader.data.vertexYOffset.value = [0.0, 0.0, 0.0, 0.0];
			shader.data.vertexZOffset.value = [0.0, 0.0, Math.sin(ang1)*size, Math.sin(ang2)*size];
		}
		{
			var spr = lowerCenterSprites[i];

			var a = angle % 45;

			if (angle % 90 >= 45)
				spr.color = colors[(i+1)%2];
			else
				spr.color = colors[i%2];

			var ang1 = ((i*45) + a) * rad;
			var ang2 = (((i+1)*45)+a) * rad;
	
			var size = 500;
	
			var shader = spr.shader;
	
			shader.data.vertexXOffset.value = [0.0, 0.0, Math.cos(ang1)*size, Math.cos(ang2)*size];
			shader.data.vertexYOffset.value = [0.0, 0.0, 800.0, 800.0];
			shader.data.vertexZOffset.value = [0.0, 0.0, Math.sin(ang1)*size, Math.sin(ang2)*size];
		}
		{
			var spr = upperCenterSprites[i];

			var a = angle % 45;

			if (angle % 90 >= 45)
				spr.color = colors[(i+1)%2];
			else
				spr.color = colors[i%2];

			var ang1 = ((i*45) + a) * rad;
			var ang2 = (((i+1)*45)+a) * rad;
	
			var size = 500;
	
			var shader = spr.shader;
	
			shader.data.vertexXOffset.value = [0.0, 0.0, Math.cos(ang1)*size, Math.cos(ang2)*size];
			shader.data.vertexYOffset.value = [0.0, 0.0, -800.0, -800.0];
			shader.data.vertexZOffset.value = [0.0, 0.0, Math.sin(ang1)*size, Math.sin(ang2)*size];
		}

	}
}