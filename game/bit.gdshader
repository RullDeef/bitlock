shader_type canvas_item;

const float border_width = 0.02;

uniform float value = 1.0;
uniform vec3 base_color = vec3(1.0, 1.0, 1.0);
uniform float clickable = 1.0;

varying vec2 pos;

void vertex() {
	pos = VERTEX.xy / 64.0;
}

void fragment() {
	vec2 uv = pos;
	float modulation = max(
		step(uv.x, border_width) + step(1.0 - uv.x, border_width),
		step(uv.y, border_width) + step(1.0 - uv.y, border_width));
	float ang_mod = step(0, sin(2.0 * TIME + 17.0 * atan(uv.y - 0.5, uv.x - 0.5)));
	modulation = modulation * ang_mod * (0.2 + 0.8 * clickable);
	COLOR = max(vec4(modulation), vec4(base_color * value, 1.0));
}
