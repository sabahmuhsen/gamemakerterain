/// @param buffer
/// @param wireframe-buffer
/// @param x
/// @param y
/// @param z
/// @param tile_x
/// @param tile_y
/// @param color
/// @param alpha

// this is much like batch_tile, except it bypasses the part where it actually needs an EntityTile,
// and also writes the data straight into a regular buffer instead of a vertex buffer

var buffer = argument0;
var wire = argument1;
var xx = argument2 * TILE_WIDTH;
var yy = argument3 * TILE_HEIGHT;
var zz = argument4 * TILE_DEPTH;
var tile_x = argument5;
var tile_y = argument6;
var color = argument7;
var alpha = argument8;
var TEXEL = 1 / TEXTURE_SIZE;

var nx = 0;
var ny = 0;
var nz = 1;

var tile_horizontal_count = TEXTURE_SIZE / Stuff.tile_size;
var tile_vertical_count = TEXTURE_SIZE / Stuff.tile_size;

var texture_width = 1 / tile_horizontal_count;
var texture_height = 1 / tile_vertical_count;

var xtex = tile_x * texture_width;
var ytex = tile_y * texture_width;

vertex_point_complete_raw(buffer, xx, yy, zz, nx, ny, nz, xtex + TEXEL, ytex + TEXEL, color, alpha);
vertex_point_complete_raw(buffer, xx + TILE_WIDTH, yy, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + TEXEL, color, alpha);
vertex_point_complete_raw(buffer, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + texture_height - TEXEL, color, alpha);

vertex_point_complete_raw(buffer, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + texture_height - TEXEL, color, alpha);
vertex_point_complete_raw(buffer, xx, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + TEXEL, ytex + texture_height - TEXEL, color, alpha);
vertex_point_complete_raw(buffer, xx, yy, zz, nx, ny, nz, xtex + TEXEL, ytex + TEXEL, color, alpha);

vertex_point_line_raw(wire, xx, yy, zz, c_white, 1);
vertex_point_line_raw(wire, xx + TILE_WIDTH, yy, zz, c_white, 1);

vertex_point_line_raw(wire, xx + TILE_WIDTH, yy, zz, c_white, 1);
vertex_point_line_raw(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);

vertex_point_line_raw(wire, xx, yy, zz, c_white, 1);
vertex_point_line_raw(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);

vertex_point_line_raw(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);
vertex_point_line_raw(wire, xx, yy + TILE_HEIGHT, zz, c_white, 1);

vertex_point_line_raw(wire, xx, yy + TILE_HEIGHT, zz, c_white, 1);
vertex_point_line_raw(wire, xx, yy, zz, c_white, 1);

return [buffer, wire];