/// @param buffer
/// @param version
/// @param DataMapContainer

var buffer = argument0;
var version = argument1;
var map_base = argument2;
var map = argument2.contents;

if (version < DataVersions.MAPS_NUKED) {
	map_base.name = buffer_read(buffer, buffer_string);
	map_base.internal_name = buffer_read(buffer, buffer_string);
	map_base.summary = buffer_read(buffer, buffer_string);
	internal_name_set(map_base);
}

var xx = buffer_read(buffer, buffer_u16);
var yy = buffer_read(buffer, buffer_u16);
var zz = buffer_read(buffer, buffer_u16);

map_base.tileset = buffer_read(buffer, buffer_u8);

data_resize_map(xx, yy, zz);

map.fog_start = buffer_read(buffer, buffer_f32);
map.fog_end = buffer_read(buffer, buffer_f32);

map.base_encounter_rate = buffer_read(buffer, buffer_u32);
map.base_encounter_deviation = buffer_read(buffer, buffer_u32);

var bools = buffer_read(buffer, buffer_u32);
map.indoors = unpack(bools, 0);
map.draw_water = unpack(bools, 1);
map.fast_travel_to = unpack(bools, 2);
map.fast_travel_from = unpack(bools, 3);
map_base.is_3d = unpack(bools, 4);

map.code = buffer_read(buffer, buffer_string);

for (var i = 0; i < array_length_1d(map.mesh_autotile_raw); i++) {
    var exists = buffer_read(buffer, buffer_bool);
    if (exists) {
        var size = buffer_read(buffer, buffer_u32);
        map.mesh_autotile_raw[i] = buffer_read_buffer(buffer, size);
	    map.mesh_autotiles[i] = vertex_create_buffer_from_buffer(map.mesh_autotile_raw[i], Camera.vertex_format);
	    vertex_freeze(map.mesh_autotiles[i]);
    }
}