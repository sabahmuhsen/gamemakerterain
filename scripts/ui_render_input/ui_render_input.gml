/// @param UIInput
/// @param x
/// @param y

var input = argument0;
var xx = argument1;
var yy = argument2;

var x1 = input.x + xx;
var y1 = input.y + yy;
var x2 = x1 + input.width;
var y2 = y1 + input.height;

var vx1 = x1 + input.value_x1;
var vy1 = y1 + input.value_y1;
var vx2 = x1 + input.value_x2;
var vy2 = y1 + input.value_y2;
var ww = vx2 - vx1;
var hh = vy2 - vy1;

var tx = ui_get_text_x(input, x1, x2);
var ty = ui_get_text_y(input, y1, y2);

// Drawing to the surface instead of the screen directly - everything drawn needs
// to be minus x1 and minus y1, because suddenly we're drawing at the origin again
if (surface_exists(input.surface) && (surface_get_width(input.surface) != ww || surface_get_height(input.surface) != hh)) {
    surface_free(input.surface);
}

if (!surface_exists(input.surface)) {
    input.surface = surface_create(ww, hh);
}

var value = input.value;

draw_set_halign(input.alignment);
draw_set_valign(input.valignment);
var c = input.color;
draw_text_colour(tx, ty, string(input.text), c, c, c, c, 1);
draw_set_valign(fa_middle);

if (script_execute(input.validation, value, input)) {
    var c = input.color;
    if (input.real_value) {
        var n = script_execute(input.value_conversion, value);
        if (!is_clamped(n, input.value_lower, input.value_upper)) {
            c = c_orange;
        }
    }
} else {
    var c = c_red;
}

var vtx = vx1 + 12;
var vty = mean(vy1, vy2);

var current_camera = view_get_camera(view_current);
view_set_camera(view_current, camera_get_default());

surface_set_target(input.surface);
draw_clear_alpha(input.interactive ? input.back_color : c_ltgray, 1);

if (input.emphasis) {
    draw_set_font(FDefault12Italic);
}
draw_text_ext_colour(vtx - x1, vty - y1, string(value), -1, vx2 - vtx, c, c, c, c, 1);
if (input.emphasis) {
    draw_set_font(FDefault12);
}
if (string_length(value) == 0) {
    draw_text_ext_colour(vtx - x1, vty - y1, string(string(input.value_default)), -1, vx2 - vtx, c_dkgray, c_dkgray, c_dkgray, c_dkgray, 1);
}

if (input.require_enter) {
    draw_sprite(spr_enter, 0, vx2 - sprite_get_width(spr_enter) - 4 - x1, vty - sprite_get_height(spr_enter) / 2 - y1);
}

if (input.interactive && dialog_is_active(input.root)) {
    if (ui_is_active(input)) {
        // this will not work correctly if there are line breaks, but fixing that is
        // like the bottom of the priority queue right now
        if (floor((current_second * 1.25) % 2) == 0) {
            var bx = vtx + string_width(string(value)) + 4;
            draw_line_width_colour(bx - x1, vty - 7 - y1, bx - x1, vty + 7 - y1, 2, c_black, c_black);
        }
        var v0 = value;
        value = string_copy(keyboard_string, 1, min(string_length(keyboard_string), input.value_limit));
        if (Controller.press_escape) {
            Controller.press_escape = false;
            value = "";
            keyboard_string = "";
        }
        input.value = value;
        
        if (script_execute(input.validation, value, input)) {
            var execute_value_change = (!input.require_enter && v0 != value) || (input.require_enter && Controller.press_enter);
            if (execute_value_change) {
                if (input.real_value) {
                    var n = script_execute(input.value_conversion, value);
                    execute_value_change = execute_value_change && is_clamped(n, input.value_lower, input.value_upper);
                }
                if (execute_value_change) {
                    input.emphasis = (input.validation == validate_string_internal_name && internal_name_get(input.value));
                    script_execute(input.onvaluechange, input);
                }
            }
        }
    }
    // activation
    var inbounds = mouse_within_rectangle_determine(vx1, vy1, vx2, vy2, input.adjust_view);
    if (inbounds) {
        if (Controller.release_left) {
            keyboard_string = input.value;
            ui_activate(input);
        }
        Stuff.element_tooltip = input;
    }
}

surface_reset_target();
draw_surface(input.surface, vx1, vy1)
draw_rectangle_colour(vx1, vy1, vx2, vy2, c_black, c_black, c_black, c_black, true);

view_set_camera(view_current, current_camera);