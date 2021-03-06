/// @param x1
/// @param y1
/// @param x2
/// @param y2
// assumes the anchor points are in the middle: (meanx, y1) and (meanx, y2)

var p1 = [argument0, argument1];
var p2 = p1;

var x0 = argument0;
var y0 = argument1;
var x1 = argument2;
var y1 = argument3;

var xa = mean(x0, x1);
var ya = y0;
var xb = xa;
var yb = y1;

for (var i = 0; i < Stuff.setting_bezier_precision; i++) {
    p1 = p2;
    p2 = bezier_point((i + 1) / Stuff.setting_bezier_precision, x0, y0, xa, ya, xb, yb, x1, y1);
    draw_line(p1[vec2.xx], p1[vec2.yy], p2[vec2.xx], p2[vec2.yy]);
}