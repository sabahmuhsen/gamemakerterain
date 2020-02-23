/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var addr_next = buffer_read(buffer, buffer_u64);

var n_autotiles = buffer_read(buffer, buffer_u16);

for (var i = 0; i < n_autotiles; i++) {
    var data = instance_create_depth(0, 0, 0, DataImageAutotile);
    
    data.picture = buffer_read_sprite(buffer);
    data.name = buffer_read(buffer, buffer_string);
    data.aframes = buffer_read(buffer, buffer_u8);
    
    if (version >= DataVersions.IMAGE_ASPEED) {
        data.aspeed = buffer_read(buffer, buffer_f32);
    }
    
    if (version >= DataVersions.ASSET_MARKERS) {
        var bools = buffer_read(buffer, buffer_u32);
        data.texture_exclude = unpack(bools, 0);
    }
    
    if (version >= DataVersions.IMAGE_HEIGHT_WIDTH_DATA) {
        data.width = buffer_read(buffer, buffer_u16);
        data.height = buffer_read(buffer, buffer_u16);
    } else {
        data.width = sprite_get_width(data.picture);
        data.height = sprite_get_height(data.picture);
    }
    
    ds_list_add(Stuff.all_graphic_autotiles, data);
}