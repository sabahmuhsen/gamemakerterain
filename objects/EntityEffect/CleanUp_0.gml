if (Stuff.is_quitting) exit;

entity_destroy();

Stuff.map.active_map.contents.population[ETypes.ENTITY_EFFECT]--;
script_execute(on_delete, id);