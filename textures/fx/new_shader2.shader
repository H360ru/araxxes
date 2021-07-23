shader_type canvas_item;
 
uniform vec4 masking_color : hint_color;
uniform float masking_range = 0.1;
uniform float masking_shadow_range = 0.1;
uniform vec2 offset;
 
void fragment()
{
	vec4 world_pixel = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	if (length(abs(masking_color - world_pixel)) >= masking_range)
	{
		if (texture(TEXTURE, UV).a >= texture(TEXTURE, UV + offset).a) //(length(abs(texture(TEXTURE, UV))) <= length(abs(texture(TEXTURE, UV + offset))))
		{
			COLOR = texture(TEXTURE, UV);
		}
		else
		{
			COLOR = texture(TEXTURE, UV + offset);
		}
		//COLOR = COLOR * vec4(1.0, 0.0, 0.0, 0.0)
	}
	else
	{
		COLOR = texture(TEXTURE, UV);
	}
	
}
