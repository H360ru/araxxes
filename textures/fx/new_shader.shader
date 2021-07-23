shader_type canvas_item;
 
uniform vec4 masking_color : hint_color;
uniform float masking_range = 0.1;
uniform float masking_shadow_range = 0.1;
uniform vec2 offset;
 
void fragment()
{
	vec4 world_pixel = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	if (length(abs(masking_color - world_pixel)) <= masking_range)
	{
		COLOR = texture(TEXTURE, UV + offset);
	}
	else
	{
		COLOR = texture(TEXTURE, UV);
	}
	
}
