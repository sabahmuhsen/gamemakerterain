/// @description void uivc_entity_event_name(UIThing);
/// @param UIThing

// safe
var index=ui_list_selection(Stuff.map.ui.element_entity_events);
var list=Stuff.map.selected_entities;
var entity=list[| 0];
var page=entity.object_events[| index];

page.name=argument0.value;
