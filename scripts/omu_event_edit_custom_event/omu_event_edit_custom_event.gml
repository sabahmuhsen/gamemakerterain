/// @param UIThing

var thing = argument0;
var selection = ui_list_selection(thing.root.root.el_list_custom);

if (selection >= 0) {
    dialog_create_event_custom(thing.root);
}