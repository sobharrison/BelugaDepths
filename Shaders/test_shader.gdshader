shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.

    
	// Hexagonal coordinates.
    vec2 h = vec2(SCREEN_UV.x + SCREEN_UV.y*.57735, SCREEN_UV.y*1.1547);

	// Normalized pixel coordinates (from 0 to 1)
    vec2 uv = FRAGCOORD.xy/SCREEN_PIXEL_SIZE;

    // Time varying pixel color
    vec3 col = 0.5*tan(TIME+SCREEN_UV.xyx+vec3(h,4));

    // Output to screen
    COLOR = vec4(tan(col), 1.0);
	
	//vec2 muv = UV;
	//muv.y = 1.0 - muv.y;
	//COLOR = vec4(UV.x, cos(SCREEN_UV.x*TIME), 0.5, 1.0);

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
