event_inherited();

// if more data is added here, and i don't think it will be, be
// sure to carry it over in both the save/load scripts and data_clone()

name = "Property";
type = DataTypes.INT;

range_min = 0;                        // int, float
range_max = 10;                       // int, float
number_scale = NumberScales.LINEAR;   // int, float
char_limit = 20;                      // string
type_guid = 0;                        // Data, enum

max_size = 1;

default_real = 0;
default_int = 0;
default_string = "";
default_code =
@"-- write Lua here";

enum DataTypes {
    INT,            // input
    ENUM,           // list
    FLOAT,          // input
    STRING,         // input
    BOOL,           // checkbox
    DATA,           // list
    CODE,           // opens in text editor
    COLOR,            // color picker
    MESH,            // list
    IMG_TILESET,
    TILE,
    AUTOTILE,
    AUDIO_BGM,        // list
    AUDIO_SE,        // list
    ANIMATION,        // list
    ENTITY,
    MAP,            // list
    IMG_BATTLER,
    IMG_OVERWORLD,
    IMG_PARTICLE,
    IMG_UI,
    IMG_ETC,
    EVENT,
    _COUNT
}

/*
 * if you want to add a new data type, you need to:
 *  1. add it to the list here
 *  2. case in omu_data_list_add
 *  3. case in uivc_list_data_list_select
 *  4. case in draw_event_node - in four different switch statements (can that be simplified?)
 *  5. case in ui_init_game_data_activate (the big one)
 *  6. case in ui_init_game_data_refresh
 *  7. case in dialog_create_data_instance_property_list
 *  8. case in serialize_load_data_instances
 *  9. case in serialize_save_data_instances
 *  10. case in serialize_load_events
 *  11. case in serialize_save_events
 *  12. text in the lists in dialog_create_select_data_types_ext (and the color, if applicable)
 *  13. case in draw_active_event
 *  14. case in uimu_data_add_data
 *  15. case in dialog_entity_data_enable_by_type
 *  16. case in serialize_save_entity
 *  17. the equilvalent in serialize_load_entity
 */

enum NumberScales {
    LINEAR,
    QUADRATIC,
    EXPONENTIAL,
}