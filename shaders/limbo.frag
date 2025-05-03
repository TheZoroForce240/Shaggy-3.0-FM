#pragma header

uniform sampler2D fakeBar;
uniform float fakeBarHeight;

uniform float zoom;
uniform float angle;
uniform float iTime;

uniform float split;

uniform float y1;
uniform float y2;

uniform float glitchChance;
uniform float glitchStrength;

uniform float x;
uniform float y;

float rand(vec2 n) {
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float rand2(vec2 n) {
	return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u * u * (3.0 - 2.0 * u);

	float res = mix(
		mix(rand(ip), rand(ip + vec2(1.0, 0.0)), u.x),
		mix(rand(ip + vec2(0.0, 1.0)), rand(ip + vec2(1.0, 1.0)), u.x),
		u.y
	);
	return res * res;
}

void main() {
	vec2 iResolution = openfl_TextureSize;
	vec2 center = vec2(0.5, 0.5);
	vec2 uv = openfl_TextureCoordv.xy;

	mat2 scaling = mat2(zoom, 0.0, 0.0, zoom);
	float angInRad = radians(angle);
	float cosAng = cos(angInRad);
	float sinAng = sin(angInRad);
	mat2 rotation = mat2(cosAng, -sinAng, sinAng, cosAng);
	mat2 aspectRatioShit = mat2(0.5625, 0.0, 0.0, 1.0);

	uv = (iResolution * uv - 0.5 * iResolution.xy) / iResolution.y;
	uv = uv * scaling;
	uv = aspectRatioShit * (rotation * uv) + center;

	vec2 borderOffset = 1.0 / iResolution;
	uv -= borderOffset * vec2(x, y);

	float yOff = (uv.x < 0.5) ? y1 : y2;
	uv.y += yOff;

	float gt = 500.0 + rand(vec2(iTime, uv.y));
	float t = floor(iTime * gt) / gt;
	float r = rand(vec2(t, t));

	float rOffset = 0.0;
	float gOffset = 0.0;

	if (mod(rand(vec2(iTime, -iTime)), 1.0) < glitchChance) {
		uv.x -= r * glitchStrength;
		rOffset = rand(vec2(uv.x, iTime)) * glitchStrength * 0.5;
		gOffset = rand(vec2(iTime, uv.x)) * glitchStrength * 0.5;
	}

	if (split != 0.0) {
		if (uv.x > 0.5 - split && uv.x < 0.5 + split &&
			uv.y >= -borderOffset.y * fakeBarHeight && uv.y <= 1.0 + borderOffset.y) {

			float v = rand(vec2(uv.y * 234.0, iTime * 12.0));
			v = (v * 0.5) + rand(vec2(iTime * 4.0, uv.y * 123.0));

			if (!(uv.x > 0.5 - (v * 0.1) && uv.x < 0.5 + (v * 0.1))) {
				gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
				float thing = rand2(vec2(uv.y * 2345.0, uv.x + iTime * 500.0));
				float thing2 = rand2(vec2(uv.x * 842.0, uv.y + iTime * 1238.0));
				float thing3 = rand2(vec2(uv.x * 2378.0, uv.y + iTime * 1643.0));
				gl_FragColor = vec4(thing2, thing, thing3, 1.0);
				gl_FragColor *= (uv.y >= 0.0) ? texture2D(bitmap, vec2(0.5, uv.y)) : vec4(0.0);
				return;
			}
			uv.x = 100.0;
		}
	}

	uv.x += (uv.x < 0.5) ? split : -split;

	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		bool l = (uv.x < 0.0 && uv.x + borderOffset.x >= 0.0);
		bool r = (uv.x > 1.0 && uv.x - borderOffset.x <= 1.0);
		bool u = (uv.y < 0.0 && uv.y + borderOffset.y >= 0.0);
		bool d = (uv.y > 1.0 && uv.y - borderOffset.y <= 1.0);

		if ((l || r || u || d) && (uv.y >= 0.0 && uv.y <= 1.0)) {
			gl_FragColor = vec4(0.18, 0.18, 0.18, 1.0);
			return;
		}

		if (uv.x >= 0.0 && uv.x <= 1.0 && uv.y < 0.0 && uv.y >= -borderOffset.y * fakeBarHeight) {
			vec2 remappedUV = vec2(uv.x, (uv.y + borderOffset.y * fakeBarHeight) / (borderOffset.y * fakeBarHeight));
			gl_FragColor = texture2D(fakeBar, remappedUV);
			return;
		}

		gl_FragColor = vec4(0.0196, 0.0196, 0.0196, 1.0);
		return;
	}

	vec4 color = texture2D(bitmap, uv);
	color.r = texture2D(bitmap, vec2(uv.x + rOffset, uv.y)).r;
	color.g = texture2D(bitmap, vec2(uv.x + gOffset, uv.y)).g;

	if (color.r >= 0.01568 && color.r < 0.02353) color.r = 0.015;
	if (color.g >= 0.01568 && color.g < 0.02353) color.g = 0.015;
	if (color.b >= 0.01568 && color.b < 0.02353) color.b = 0.015;

	gl_FragColor = color;
}
