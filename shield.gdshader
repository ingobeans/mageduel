shader_type canvas_item;

instance uniform vec4 shield_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}
void fragment() {
	float radius = 0.3;
	float border = 0.01;

	vec3 c = shield_color.rgb;
	float v = length(UV.xy - vec2(0.5,0.5));
	if (v > radius) {
		v = 0.0;
	}else if (v > radius-border) {
		v = 1.0;
		c = vec3(1.0,1.0,1.0);
	} else {
		v = v*v / (radius*radius);
	}
	COLOR = vec4(c,v);
}
