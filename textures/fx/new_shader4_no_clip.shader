shader_type canvas_item;
 
uniform vec4 masking_color : hint_color;
uniform float masking_range = 0.1;
uniform float masking_shadow_range = 0.1;
uniform vec2 offset;
uniform float _uv_offset;
uniform float scale = 2.;

uniform vec2 texture_size;

// The texture to use as a color mask.
// For these examples, it will be the ColorMask viewport texture.
uniform sampler2D mask_texture : hint_black;

void vertex()
{
	VERTEX *= scale;
	VERTEX += vec2(texture_size.x/2., texture_size.y/2.)*(scale - 1.);
//	VERTEX += vec2(50., 50.);//vec2(TEXTURE_PIXEL_SIZE.x/2., TEXTURE_PIXEL_SIZE.y/2.) * scale;
}

void fragment()
{
	vec4 world_pixel = texture(mask_texture, SCREEN_UV) * vec4(0.0,0.0,0.0,1.0);

//	vec2 _uv = SCREEN_UV;
//	_uv.y = _uv.y + _uv_offset;
//	COLOR = texture(mask_texture, _uv);//world_pixel;
//	COLOR.rbga = texture(mask_texture, SCREEN_UV).rbga;

	if (world_pixel.a >= 0.1)//(length(abs(masking_color - world_pixel)) >= masking_range)
	{
		if (texture(TEXTURE, UV*scale).a >= texture(TEXTURE, UV*scale + offset).a) //(length(abs(texture(TEXTURE, UV))) <= length(abs(texture(TEXTURE, UV + offset))))
		{
			COLOR = texture(TEXTURE, UV*scale);
//			COLOR.a -= 0.15
		}
		else
		{
			COLOR = texture(TEXTURE, UV*scale + offset)// * vec4(1.0, 0.0, 0.0, 0.0);
//			COLOR.a += 0.15
		}
		//COLOR = COLOR * vec4(1.0, 0.0, 0.0, 0.0)
	}
	else
	{
		COLOR = texture(TEXTURE, UV*scale);
//		COLOR.a -= 0.15
	}
	
}
