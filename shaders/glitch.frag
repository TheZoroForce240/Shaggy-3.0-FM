#pragma header


uniform float iTime;
uniform float enabled;
uniform float flashingLights;

float rand(vec2 co){
		return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main()
{
	vec2 uv = openfl_TextureCoordv.xy;
	vec4 spritecolor = flixel_texture2D(bitmap, uv);
	

	if (enabled == 1.0)
	{

		float random = rand(vec2(iTime, -iTime));
		float random2 = rand(vec2(-iTime, iTime));
	
		
	
		if (sin(iTime*6.0) > 0.96) //uv offsets
		{
			if (uv.x > abs(sin(random)))
				uv.x += abs(cos(random2))*0.2;
		}
		else if (sin(iTime*10.0) > 0.9)
		{
			if (uv.y > abs(sin(random)))
				uv.y -= abs(cos(random2))*0.3;
		}
		spritecolor = flixel_texture2D(bitmap, uv); //reset with new uv

		if (flashingLights == 1.0)
		{
			if (cos(iTime*8.0) > 0.9) //chromatic aberration
			{
				spritecolor.r = flixel_texture2D(bitmap, uv+(random*0.04)).r;
				spritecolor.g = flixel_texture2D(bitmap, uv-(random2*0.04)).g;
			}
			if (sin(iTime*7.0) > 0.98) //invert colors
			{
				//float random2 = rand(openfl_TextureCoordv);
				
				spritecolor.rgb = 0.0-spritecolor.rgb+1.0;
				spritecolor.rgb *= spritecolor.a;
			}
			if (cos(iTime*5.0) > 0.9)
			{
				if (mod(floor(uv.y*10.0), 2.0) == 0.0)
				{
					uv.x -= abs(sin(random2))*0.2;
				}
				else 
				{
					uv.x += abs(sin(random2))*0.2;
				}
			}
		}
		else 
		{
			if (cos(iTime*8.0) > 0.9) //uv offsets again lol
			{
				if (uv.x > abs(cos(random)))
					uv.x -= abs(sin(random2))*0.2;
			}
			if (sin(iTime*7.0) > 0.98)
			{
				if (uv.y > abs(cos(random)))
					uv.y += abs(sin(random2))*0.3;
			}
			spritecolor = flixel_texture2D(bitmap, uv); //reset with new uv
		}
		
	}


	//fix for transparent window
	if (spritecolor.r <= 0.005)
		spritecolor.r = 0.0;
	if (spritecolor.g == 0.005)
		spritecolor.g = 0.0;
	if (spritecolor.b == 0.005)
		spritecolor.b = 0.0;

	float alpha = flixel_texture2D(bitmap, uv).a;
	if (alpha == 0.005)
		alpha = 0.001;


	gl_FragColor = vec4(spritecolor.rgb, alpha);
}