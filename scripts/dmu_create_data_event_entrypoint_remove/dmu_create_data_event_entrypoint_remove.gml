/// @param UIButton

var button = argument0;
var root_element = button.root.root;

var instance = root_element.instance;
ds_list_set(instance.values[| root_element.key], 0, 0);
root_element.text = "Select Event";
dmu_dialog_commit(button);