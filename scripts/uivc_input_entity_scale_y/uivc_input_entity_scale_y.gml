/// @param UIInput

var input = argument0;

var list = Stuff.map.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    var thing = list[| i];
    if (thing.scalable) {
        thing.scale_yy = real(input.value);
        thing.modification = Modifications.UPDATE;
        ds_list_add(Stuff.map.changes, thing);
    }
}