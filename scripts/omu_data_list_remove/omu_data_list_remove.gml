/// @param UIThing

var thing = argument0;

var selection = ui_list_selection(Stuff.data.ui.el_instances);
var data = guid_get(Stuff.data.ui.active_type_guid);
var instance = guid_get(data.instances[| selection].GUID);
var plist = instance.values[| thing.key];
var pselection = ui_list_selection(thing.root.el_list_main);

if (pselection >= 0 && ds_list_size(plist) > 1) {
    ds_list_delete(plist, pselection);
    // plist and the list element's list point to the same data structure
    // and you can remove from either, although i prefer to remove from
    // the plist because that's the "original"
}