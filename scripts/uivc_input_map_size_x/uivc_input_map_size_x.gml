/// @param UIInput

var input = argument0;
var selection = ui_list_selection(input.root.el_map_list);

if (selection + 1) {
    var map = Stuff.all_maps[| selection];
    var clear = true;
    var xx = real(input.value);
    for (var i = 0; i < ds_list_size(map.contents.all_entities); i++) {
        clear = clear && (map.contents.all_entities[| i].xx < xx);
    }
    
    if (clear) {
        data_resize_map(map, xx, map.yy, map.zz);
    } else {
        var dialog = dialog_create_yes_or_no(input, "If you do this, entities will be deleted and you will not be able to get them back. Is this okay?", dc_map_resize, undefined, undefined, undefined, dmu_dialog_cancel_reset_map_dimension_values);
        dialog.map = map;
        dialog.xx = xx;
        dialog.yy = map.yy;
        dialog.zz = map.zz;
    }
}