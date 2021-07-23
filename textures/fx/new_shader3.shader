shader_type canvas_item;
 
uniform vec4 masking_color : hint_color;
uniform float masking_range = 0.1;
uniform float masking_shadow_range = 0.1;
uniform vec2 offset;
uniform float _uv_offset;

// The texture to use as a color mask.
// For these examples, it will be the ColorMask viewport texture.
uniform sampler2D mask_texture : hint_black;
 
void fragment()
{
	vec4 world_pixel = texture(mask_texture, SCREEN_UV) * vec4(0.0,0.0,0.0,1.0);

//	vec2 _uv = SCREEN_UV;
//	_uv.y = _uv.y + _uv_offset;
//	COLOR = texture(mask_texture, _uv);//world_pixel;
//	COLOR.rbga = texture(mask_texture, SCREEN_UV).rbga;

	if (world_pixel.a >= 0.1)//(length(abs(masking_color - world_pixel)) >= masking_range)
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
