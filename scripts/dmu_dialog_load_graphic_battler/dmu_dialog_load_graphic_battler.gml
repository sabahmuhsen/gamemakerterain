/// @param UIButton

var button = argument0;

var fn = get_open_filename_image();

if (file_exists(fn)) {
    graphics_add_generic(fn, PREFIX_GRAPHIC_BATTLER, button.root.el_list.entries);
}