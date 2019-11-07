/// @param EditorModeTerrain

var terrain = argument0;

if (mouse_within_view(view_3d) && !dialog_exists()) {
    if (terrain.orthographic) {
        control_terrain_3d_ortho(terrain);
    } else {
        control_terrain_3d(terrain);
    }
}

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);

if (terrain.view_water) {
    graphics_draw_water();
}

shader_set(shd_basic);
shader_set_uniform_i(shader_get_uniform(shd_basic, "lightEnabled"), true);
shader_set_uniform_i(shader_get_uniform(shd_basic, "lightCount"), 1);
shader_set_uniform_f_array(shader_get_uniform(shd_basic, "lightData"), [
	1, 1, -1, 0,
		0, 0, 0, 0,
		1, 1, 1, 0,
]);

transform_set(0, 0, 0, 0, 0, 0, terrain.view_scale, terrain.view_scale, terrain.view_scale);
vertex_submit(terrain.terrain_buffer, pr_trianglelist, sprite_get_texture(terrain.texture, 0));

shader_reset();
transform_reset();
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);