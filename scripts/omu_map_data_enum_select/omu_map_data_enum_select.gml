/// @param UIButton

var button = argument0;

var dialog = dialog_create_data_enum_select(button);
dialog.el_confirm.onmouseup = dc_map_data_property_set_enum;