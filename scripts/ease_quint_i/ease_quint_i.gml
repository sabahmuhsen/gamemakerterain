/// @param v0
/// @param v1
/// @param f

// ease quintic in

// weird arguments but they match the format used by http://www.gizma.com/easing
var t = argument2;
var b = argument0;
var c = argument1 - argument0;

return c * t * t * t * t * t + b;