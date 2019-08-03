/// @param DataAnimation
/// @param layer
/// @param current-moment

var animation = argument0;
var timeline_layer = argument1;
var moment = argument2;
    
for (var i = moment + 1; i < animation.moments; i++) {
    var keyframe = animation_get_keyframe(animation, timeline_layer, i);
    if (keyframe) {
        // @todo gml update lightweight objects maybe?
        return keyframe;
    }
}

return noone;