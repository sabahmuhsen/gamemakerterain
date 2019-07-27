/// @param UIList

var list = argument0;

if (!ds_list_empty(Stuff.all_animations)) {
    var selection = ui_list_selection(list);
    list.root.active_animation = 0;      // assume null until proven otherwise
    
    if (selection >= 0) {
        if (Stuff.setting_alphabetize_lists) {
            var listofthings = ds_list_sort_name_sucks(Stuff.all_animations);
        } else {
            var listofthings = Stuff.all_animations;
        }
        
        list.root.active_animation = listofthings[| selection];
        list.root.el_name.value = list.root.active_animation.name;
        list.root.el_internal_name.value = list.root.active_animation.internal_name;
        
        if (Stuff.setting_alphabetize_lists) {
            ds_list_destroy(listofthings);
        } else {
            // if it's not alphabetized the list is just all_animations[] which you DEFINITELY DO
            // NOT WANT TO DELETE.
        }
    }
}