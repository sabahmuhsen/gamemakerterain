/// @param Dialog

var dialog = argument0;

var dw = 320;
var dh = 640;

var dg = dialog_create(dw, dh, "Select Event", dialog_default, dc_close_no_questions_asked, dialog);
dg.event = noone;

var columns = 1;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var yy = 64;
var spacing = 16;

var el_list = create_list(16, yy, "Select an event", "<how do you even have no events?>", ew, eh, 20, null, false, dg, Stuff.all_events);
el_list.entries_are = ListEntries.INSTANCES;
dg.el_list = el_list;

if (dialog.instance) {
    for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
        if (Stuff.all_events[| i].GUID == dialog.event_guid) {
            ui_list_select(el_list, i);
            break;
        }
    }
}

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Commit", b_width, b_height, fa_center, dmu_create_data_event_entrypoint_list, dg);

ds_list_add(dg.contents,
    el_list,
    el_confirm
);

return dg;