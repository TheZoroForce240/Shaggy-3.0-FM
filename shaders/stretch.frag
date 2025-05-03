#pragma header


uniform float iTime;


vec4 render( vec2 uv )
{
	uv.x += iTime;
	
	if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
		uv.x = (0.0-uv.x)+1.0;
	if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
		uv.y = (0.0-uv.y)+1.0;



	return flixel_texture2D( bitmap, vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0))) );
}


void main()
{
	vec2 uv = openfl_TextureCoordv.xy;

	uv -= vec2(0.5, 0.5);

	uv.x *= 2.0;

	uv.x = uv.x / ((0.0 - abs(uv.x)) + 1.0);

	uv.x /= 8.0;

	uv += vec2(0.5, 0.5);

	vec2 blocks = openfl_TextureSize / vec2(3.0,3.0);
    uv = floor(uv * blocks) / blocks;

	vec4 spritecolor = render(uv);

	gl_FragColor = spritecolor;
}