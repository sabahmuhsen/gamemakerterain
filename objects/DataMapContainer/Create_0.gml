/// @description map properties

event_inherited();

name = "Map";
summary = "it does map things";

file_location = DataFileLocations.DATA;
data_buffer = noone;
contents = noone;
version = 0;

tiled_map_id = "";

preview = noone;
wpreview = noone;
cspreview = noone;
cpreview = noone;

// all of the map properties have finally been moved over to the map container

xx = 64;									// dimensions
yy = 64;
zz = 8;

tileset = 0;								// index
is_3d = true;								// bool
fog_start = 256;							// float
fog_end = 1024;								// float
indoors = false;							// bool
draw_water = true;							// bool
fast_travel_to = true;						// bool
fast_travel_from = true;					// bool
base_encounter_rate = 8;					// steps?
base_encounter_deviation = 4;				// ehh

discovery = 0;								// index

code = Stuff.default_lua_map;				// code

mesh_autotiles = array_create(48);
mesh_autotile_raw = array_create(48);
array_clear(mesh_autotiles, noone);
array_clear(mesh_autotile_raw, noone);

ds_list_add(Stuff.all_maps, id);