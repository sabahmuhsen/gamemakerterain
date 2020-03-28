/// @param UIList

var list = argument0;

var selection = Stuff.all_event_prefabs[| ui_list_selection(list)];
ui_list_deselect(list);
ds_list_sort_name(Stuff.all_event_prefabs);

for (var i = 0; i < ds_list_size(Stuff.all_event_prefabs); i++) {
    if (Stuff.all_event_prefabs[| i] == selection) {
        ui_list_select(list, i, true);
        break;
    }
}