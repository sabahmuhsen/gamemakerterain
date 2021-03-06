/// @param UIList

var list = argument0;

var data = guid_get(Stuff.data.ui.active_type_guid);
var selection = ui_list_selection(Stuff.data.ui.el_instances);
var data_selection = ui_list_selection(list);

if ((selection + 1)) {
    var instance = data.instances[| selection];
    if (data_selection + 1) {
        // @gml
        // because game maker can't handle doing all of these accessors in the same
        // line apparently
        ds_list_set(instance.values[| list.key], 0, list.entries[| data_selection].GUID);
    } else {
        ds_list_set(instance.values[| list.key], 0, 0);
    }
}