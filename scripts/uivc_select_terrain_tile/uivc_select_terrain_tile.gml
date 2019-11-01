/// @param UITileSelector
/// @param tx
/// @param ty

var selector = argument[0];
var tx = argument[1];
var ty = argument[2];
var terrain = Stuff.terrain;

var ts = get_active_tileset();

selector.tile_x = tx;
selector.tile_y = ty;
terrain.tile_brush_x = tx * terrain.tile_size;
terrain.tile_brush_y = ty * terrain.tile_size;