/// @param guid

var data = guid_get(argument0);

ds_list_delete(Stuff.all_graphic_overworlds, ds_list_find_index(Stuff.all_graphic_overworlds, data));
instance_activate_object(data);
instance_destroy(data);