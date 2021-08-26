shader_type canvas_item;

uniform vec4 bonus: hint_color;

void fragment() {
	vec4 current = texture(TEXTURE, UV);
	if (current.a != 0.0)
		COLOR = bonus;
	else
		COLOR = current;

}