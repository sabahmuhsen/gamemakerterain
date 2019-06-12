/// @description map properties

event_inherited();

deactivateable = false;
deleteable = false;

xx = 64;                                  // dimensions
yy = 64;
zz = 8;

name = "Map";                             // visible to the player
internal_name = "MAP";                    // the name of the file that the map attaches to
summary = "It's a map, that does map things";

tileset = 0;                              // index

audio_bgm = "";                           // internal name
audio_ambient = ds_list_create();         // list of internal names
audio_ambient_frequencies = ds_list_create();  // list of bytes

fog_start = 256;                          // float
fog_end = 1024;                           // float
indoors = false;                          // bool
draw_water = true;                        // bool
fast_travel_to = true;                    // bool
fast_travel_from = true;                  // bool

is_3d = true;

discovery = 0;                            // index

weather_code =
@"-- write Lua code that you want to determine the weather effects here.
-- you can add other functions or do pretty much anything else allowed by Lua, but don't
-- remove the Update function (with its argument list) and it should return a value
-- corresponding to the weather you want to initiate.

function Update(current)
    return 0
end";

// internal stuff
batches = ds_list_create();          // vertex buffers
batches_wire = ds_list_create();

batch_instances = ds_list_create();       // entities
batch_in_the_future = ds_list_create();   // entities
dynamic = ds_list_create();               // entities

all_entities = ds_list_create();          // entities

map_grid = map_create_grid(xx, yy, zz);

frozen = vertex_create_buffer();          // everything that will be a single batch in
                                        // the game

population = [0, 0, 0, 0, 0, 0, 0];
population_static = 0;
population_solid = 0;