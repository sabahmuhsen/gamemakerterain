/// @param animation
/// @param layer
/// @param current-moment

var animation = argument0;
var timeline_layer = argument1;
var moment = argument2;

var kf_current = noone;
var kf_previous = noone;
var kf_next = noone;

kf_current = animation_get_keyframe(animation, timeline_layer, moment);
do {
    kf_previous = animation_get_preivous_keyframe(animation, timeline_layer, kf_previous ? kf_previous.moment : moment);
} until (!kf_previous || kf_previous.tween_color != AnimationTweens.IGNORE);
do {
    kf_next = animation_get_next_keyframe(animation, timeline_layer, kf_next ? kf_next.moment : moment);
} until (!kf_next || kf_next.tween_color != AnimationTweens.IGNORE);

var type = kf_previous ? kf_previous.tween_color : AnimationTweens.NONE;

var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[| kf_current.relative] : noone;
var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[| kf_previous.relative] : noone;
var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[| kf_next.relative] : noone;

// if no previous keyframe exists the value will always be the default (here, zero);
// if not next keyframe exists the value will always be the previous value
var value_default = animation_get_layer(animation, timeline_layer).color;
var value_now = kf_current ? kf_current.color : value_default;
var value_previous = kf_previous ? kf_previous.color : value_default;
var value_next = kf_next ? kf_next.color : (animation.loops ? value_default : value_previous);
var moment_previous = kf_previous ? kf_previous.moment : 0;
var moment_next = kf_next ? kf_next.moment : animation.moments;
var f = normalize(moment, moment_previous, moment_next);

if (kf_current) {
    return value_now;
}

// bgr
var r_previous = value_previous & 0x0000ff;
var g_previous = (value_previous & 0x00ff00) >> 8;
var b_previous = (value_previous & 0xff0000) >> 16;

var r_next = value_next & 0x0000ff;
var g_next = (value_next & 0x00ff00) >> 8;
var b_next = (value_next & 0xff0000) >> 16;

// only need to check for previous keyframe because if there is no next keyframe, the "next"
// value will be the same as previous and tweening will just output the same value anyway
var r_current = tween(r_previous, r_next, f, type);
var g_current = tween(g_previous, g_next, f, type);
var b_current = tween(b_previous, b_next, f, type);

return (b_current << 16) | (g_current << 8) | r_current;