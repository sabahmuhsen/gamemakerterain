/// @param EditorModeTerrain

var mode = argument0;

if (mouse_within_view(view_3d) && !dialog_exists()) {
    if (mode.orthographic) {
        control_terrain_3d_ortho(mode);
    } else {
        control_terrain_3d(mode);
    }
}

var camera = camera_get_default();
var vw = view_get_wport(view_3d);
var vh = view_get_hport(view_3d);

if (mode.orthographic) {
    var view = matrix_build_lookat(mode.x, mode.y, CAMERA_ZFAR - 256, mode.x, mode.y, 0, 0, 1, 0);
    var proj = matrix_build_projection_ortho(-vw * mode.orthographic_scale, vh * mode.orthographic_scale, CAMERA_ZNEAR, CAMERA_ZFAR);
} else {
    var view = matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup);
    var proj = matrix_build_projection_perspective_fov(-mode.fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR);
}

shader_set(shd_basic_lighting);
shader_set_uniform_i(shader_get_uniform(shd_basic_lighting, "lightEnabled"), true);
shader_set_uniform_i(shader_get_uniform(shd_basic_lighting, "lightCount"), 1);
shader_set_uniform_f_array(shader_get_uniform(shd_basic_lighting, "lightData"), [
    1, 1, -1, 1,
        0, 0, 0, 0,
        1, 1, 1, 0,
]);

transform_set(0, 0, 0, 0, 0, 0, mode.view_scale, mode.view_scale, mode.view_scale);

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

// base terrain layer

if (!surface_exists(mode.depth_surface_base)) {
    mode.depth_surface_base = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));
}

surface_set_target(mode.depth_surface_base);

camera_set_view_mat(camera, view);
camera_set_proj_mat(camera, proj);
camera_apply(camera);

draw_clear_alpha(c_black, 0);
vertex_submit(mode.terrain_buffer, pr_trianglelist, sprite_get_texture(mode.texture, 0));
vertex_submit(Stuff.graphics.axes, pr_linelist, -1);
surface_reset_target();

// top terrain layer
/*
if (!surface_exists(mode.depth_surface_top)) {
    mode.depth_surface_top = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));
}

surface_set_target(mode.depth_surface_top);

camera_set_view_mat(camera, view);
camera_set_proj_mat(camera, proj);
camera_apply(camera);

draw_clear_alpha(c_black, 0);
vertex_submit(mode.terrain_buffer, pr_trianglelist, sprite_get_texture(mode.texture, 0));
vertex_submit(Stuff.graphics.axes, pr_linelist, -1);
*/
//surface_reset_target();

shader_reset();
transform_reset();