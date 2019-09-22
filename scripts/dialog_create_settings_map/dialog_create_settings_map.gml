/// @param Dialog

var dialog = argument0;
// no need to check that it exists because the button will be disabled if it doesn't
var map = Stuff.all_maps[| ui_list_selection(dialog.root.el_map_list)];
var map_contents = map.contents;

var dw = 640;
var dh = 640;

var dg = dialog_create(dw, dh, "More Map Settings", undefined, undefined, dialog);
dg.map = map;

var ew = (dw - 64) / 2;
var eh = 24;
var spacing = 16;

var c2 = dw / 2 + 16;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var yy = 64;
var yy_base = 64;

var el_other = create_text(16, yy, "Settings: Other", ew, eh, fa_left, ew, dg);
yy = yy + el_other.height + spacing;

var el_other_3d = create_checkbox(16, yy, "Is 3D?", ew, eh, uivc_settings_map_3d, "", map.is_3d, dg);
yy = yy + el_other_3d.height + spacing;

var el_other_fog_start = create_input(16, yy, "Fog Start", ew, eh, uivc_settings_map_fog_start, "", map.fog_start, "512?", validate_int, ui_value_real, 1, 0xffff, 5, vx1, vy1, vx2, vy2, dg);
dg.el_other_fog_start = el_other_fog_start;
yy = yy + el_other_fog_start.height + spacing;

var el_other_fog_end = create_input(16, yy, "Fog End", ew, eh, uivc_settings_map_fog_end, "", map.fog_end, "2048?", validate_int, ui_value_real, 1, 0xffff, 5, vx1, vy1, vx2, vy2, dg);
dg.el_other_fog_end = el_other_fog_end;
yy = yy + el_other_fog_end.height + spacing;

var el_other_indoors = create_checkbox(16, yy, "Is indoors?", ew, eh, uivc_settings_map_indoors, "", map.indoors, dg);
yy = yy + el_other_indoors.height + spacing;

var el_other_water = create_checkbox(16, yy, "Render water?", ew, eh, uivc_settings_map_water, "", map.draw_water, dg);
yy = yy + el_other_water.height + spacing;

var el_other_fast_travel_to = create_checkbox(16, yy, "Can fast travel to?", ew, eh, uivc_settings_map_fast_travel_to, "", map.fast_travel_to, dg);
yy = yy + el_other_fast_travel_to.height + spacing;

var el_other_fast_travel_from = create_checkbox(16, yy, "Can fast travel from?", ew, eh, uivc_settings_map_fast_travel_from, "", map.fast_travel_from, dg);
yy = yy + el_other_fast_travel_from.height + spacing;

yy = yy_base;

var el_code_heading = create_text(c2, yy, "Update Code", ew, eh, fa_left, ew, dg);
yy = yy + el_code_heading.height + spacing;

var el_code = create_input_code(c2, yy, "", ew, eh, 0, vy1, vx2, vy2, map.code, uivc_map_code, dg);
yy = yy + el_code.height + spacing;

var el_encounter_heading = create_text(c2, yy, "Encounter Stuff", ew, eh, fa_left, ew, dg);
yy = yy + el_encounter_heading.height + spacing;

var el_encounter_base = create_input(c2, yy, "Base Rate", ew, eh, uivc_settings_map_encounter_base, 0, map.base_encounter_rate, "0 for off", validate_int, ui_value_real, 0, 1000000, 7, vx1, vy1, vx2, vy2, dg);
yy = yy + el_encounter_base.height + spacing;

var el_encounter_deviation = create_input(c2, yy, "Deviation", ew, eh, uivc_settings_map_encounter_deviation, 0, map.base_encounter_deviation, "Probably steps", validate_int, ui_value_real, 0, 1000000, 7, vx1, vy1, vx2, vy2, dg);
yy = yy + el_encounter_deviation.height + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Commit", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_other, el_other_3d, el_other_fog_start, el_other_fog_end, el_other_indoors, el_other_water,
	el_other_fast_travel_to, el_other_fast_travel_from,
    el_code_heading, el_code,
    el_encounter_heading, el_encounter_base, el_encounter_deviation,
    el_confirm);

keyboard_string = "";

return dg;