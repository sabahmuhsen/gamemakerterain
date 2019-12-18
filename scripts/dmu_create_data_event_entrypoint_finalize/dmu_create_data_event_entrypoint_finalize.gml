/// @param UIButton

var button = argument0;

var selection = ui_list_selection(button.root.el_list);
if (selection + 1) {
    var entrypoint = button.root.el_list.entries[| selection];
    
    var root_element = button.root.root.root.root;
    var instance = root_element.instance;
    ds_list_set(instance.values[| root_element.key], 0, entrypoint.GUID);
    root_element.text = entrypoint.name;
}

dmu_dialog_commit(button);
dmu_dialog_commit(button);