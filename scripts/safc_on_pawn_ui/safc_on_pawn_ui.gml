/// @param EntityPawn

var pawn = argument0;

safc_on_entity_ui(pawn);

Stuff.map.ui.element_entity_mesh_animated.interactive = false;

ui_input_set_value(Stuff.map.ui.element_entity_pawn_frame, string(floor(pawn.frame)));
Stuff.map.ui.element_entity_pawn_direction.value = pawn.map_direction;
Stuff.map.ui.element_entity_pawn_animating.value = pawn.is_animating;

ui_list_deselect(Stuff.map.ui.element_entity_pawn_sprite);
for (var i = 0; i < ds_list_size(Stuff.all_graphic_overworlds); i++) {
    if (Stuff.all_graphic_overworlds[| i].GUID == pawn.overworld_sprite) {
        ui_list_select(Stuff.map.ui.element_entity_pawn_sprite, i, true);
        break;
    }
}

Stuff.map.ui.element_entity_pawn_frame.interactive = true;
Stuff.map.ui.element_entity_pawn_direction.interactive = true;
Stuff.map.ui.element_entity_pawn_animating.interactive = true;
Stuff.map.ui.element_entity_pawn_sprite.interactive = true;