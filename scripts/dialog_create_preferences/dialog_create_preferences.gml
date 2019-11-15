/// @param Dialog

var dialog = argument0;

var dw = 512;
var dh = 640;

var dg = dialog_create(dw, dh, "Preferences", dialog_default, dc_close_no_questions_asked, dialog);

var ew = (dw - 64) / 2;
var eh = 24;

var col1_x = 16;
var col2_x = dw / 2 + 16;

var vx1 = dw / 4 + 16;
var vy1 = 0;
var vx2 = vx1 + 80;
var vy2 = vy1 + eh;

var yy = 64;
var yy_base = yy;
var spacing = 16;

var el_bezier = create_input(col1_x, yy, "Bezier precision:", ew, eh, uivc_bezier_precision, Stuff.setting_bezier_precision, "0...16", validate_int, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
el_bezier.tooltip = "Higher-precision bezier curves look better, but take more computing power to draw. Lowering this will not fix performance issues, but it may help.";
yy = yy + el_bezier.height + spacing;

var el_tooltips = create_checkbox(col1_x, yy, "Show Tooltips", ew, eh, uivc_show_tooltips, Stuff.setting_tooltip, dg);
el_tooltips.tooltip = "These things.";
yy = yy + el_tooltips.height + spacing;

var el_backups = create_input(col1_x, yy, "Backups: ", ew, eh, uivc_backups, Stuff.setting_backups, "0...9", validate_int, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
el_backups.tooltip = "In case something goes wrong and you wish to recover a previous data file. A backup will be created every time you save; the editor will NOT otherwise autosave its state, because these data files can be very large and that would cause it to momentarily freeze.";
yy = yy + el_backups.height + spacing;

var el_autosave = create_checkbox(col1_x, yy, "Automatic Backups", ew, eh, uivc_autosave, Stuff.setting_autosave, dg);
el_autosave.tooltip = el_backups.tooltip;
yy = yy + el_autosave.height + spacing;

var el_clear_backups = create_button(col1_x, yy, "Clean Backups", ew, eh, fa_center, omu_clear_backups, dg);
el_clear_backups.tooltip = "This will be permenant. It is recommended that you open the backup folder and decide what to keep for yourself if you think they're starting to waste a lot of space."
yy = yy + el_clear_backups.height + spacing;

var el_view_backups = create_button(col1_x, yy, "View Backup Folder", ew, eh, fa_center, omu_view_backups, dg);
el_view_backups.tooltip = "Opens the folder on your computer where backups are stored."
yy = yy + el_view_backups.height + spacing;

var el_npc_animation = create_input(col1_x, yy, "NPC speed:", ew, eh, uivc_bezier_precision, Stuff.setting_npc_animate_rate, "0...9", validate_int, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
el_npc_animation.tooltip = "The speed at which NPC (Pawn) entities will animate.";
yy = yy + el_npc_animation.height + spacing;

var el_ui_color = create_color_picker(col1_x, yy, "UI Color:", ew, eh, uivc_ui_color, Stuff.setting_color, vx1, vy1, vx2, vy2, dg);
el_ui_color.tooltip = "The default color of the UI. I like green but you can make it something else if you don't like green.";
yy = yy + el_ui_color.height + spacing;

yy = yy_base;

var el_code_ext = create_radio_array(col2_x + col1_x, yy, "Code File Extension:", ew, eh, uivc_code_extension, Stuff.setting_code_extension, dg);
el_code_ext.tooltip = "This only really affects the text editor you want to be able to edit Lua code with. Plain text files will open with Notepad by default, but if you have another editor set you can use that instead.";
create_radio_array_options(el_code_ext, ["*.txt", "*.lua"]);

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Commit", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_bezier, el_tooltips, el_backups, el_autosave, el_npc_animation, el_ui_color,
    el_clear_backups, el_view_backups,
    el_code_ext,
    el_confirm
);

return dg;