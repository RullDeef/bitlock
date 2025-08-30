shader_type canvas_item;

// tweakables
uniform float speed : hint_range(0.0, 5.0) = 1.0;   // scroll speed (cycles/sec)
uniform float scale  : hint_range(1.0, 50.0) = 64.0; // pattern density

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// seamless repeating UV
	vec2 uv = FRAGCOORD.xy / scale;

	// animate one of the coordinates with TIME
	uv.x += TIME * speed;
	uv.x -= fract(5.0 * (uv.y + TIME / 3.0)) / 20.0;

	// a simple checker / stripe pattern
	float c = step(0.5, fract(uv.x)) * step(0.5, fract(uv.y));

	// choose two colors for the pattern
	vec3 colA = vec3(0.05, 0.08, 0.03);
	vec3 colB = vec3(0.05, 0.12, 0.15);

	COLOR = vec4(mix(colA, colB, c), 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
