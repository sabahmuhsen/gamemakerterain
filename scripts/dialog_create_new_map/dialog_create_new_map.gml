/// @param Dialog

var dialog = argument0;

var dw = 320;
var dh = 480;

var dg = dialog_create(dw, dh, "New Map", undefined, undefined, dialog);

var columns = 1;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;
var spacing = 16;

var col1_x = dw * 0 / columns + spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var yy = 64;
var yy_base = 64;

var el_heading = create_text(col1_x, yy, "Map Settings", ew, eh, fa_left, ew, dg);

yy += el_heading.height + spacing;

var el_name = create_input(col1_x, yy, "Name:", ew, eh, null, "Map " + string(ds_list_size(Stuff.all_maps) + 1), "The name of the map", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
el_name.tooltip = "The name of the map, as it will be visible to the player.";
dg.el_name = el_name;

yy += el_name.height + spacing;

var el_size_note = create_text(col1_x, yy, "Maps can go up to " + string(MAP_AXIS_LIMIT) + " in any dimension, but the total volume must be lower than " + string_comma(MAP_VOLUME_LIMIT) + ". And greater than zero. Obviously.", ew, eh, fa_left, ew, dg);
el_size_note.valignment = fa_top;

yy += el_size_note.height + spacing * 6;

var el_x = create_input(col1_x, yy, "Width (X):", ew, eh, null, 64, "", validate_int_create_map_size, 1, MAP_AXIS_LIMIT, 4, vx1, vy1, vx2, vy2, dg);
el_x.tooltip = "The width of the map, in tiles.";
dg.el_x = el_x;

yy += el_x.height + spacing;

var el_y = create_input(col1_x, yy, "Height (Y):", ew, eh, null, 64, "", validate_int_create_map_size, 1, MAP_AXIS_LIMIT, 4, vx1, vy1, vx2, vy2, dg);
el_y.tooltip = "The height of the map, in tiles.";
dg.el_y = el_y;

yy += el_y.height + spacing;

var el_z = create_input(col1_x, yy, "Depth (Z):", ew, eh, null, 8, "", validate_int_create_map_size, 1, MAP_AXIS_LIMIT, 4, vx1, vy1, vx2, vy2, dg);
el_z.tooltip = "The depth of the map, in tiles.";
dg.el_z = el_z;

yy += el_z.height + spacing;

var el_grid = create_checkbox(col1_x, yy, "Aligned to Grid?", ew, eh, null, true, dg);
el_grid.tooltip = "In the future I plan on allowing maps to be free of the tile grid, but that is not a priority right now.";
dg.el_grid = el_grid;

yy += el_grid.height + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Okay", b_width, b_height, fa_center, dmu_map_add, dg);

ds_list_add(dg.contents,
    el_heading,
    el_name,
    el_x,
    el_y,
    el_z,
    el_size_note,
    el_grid,
    el_confirm
);

return dg;