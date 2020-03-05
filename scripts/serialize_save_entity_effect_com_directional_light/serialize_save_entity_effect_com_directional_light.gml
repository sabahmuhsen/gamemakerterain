/// @param buffer
/// @param EffectComponent

var buffer = argument0;
var component = argument1;

serialize_save_entity_effect_com(buffer, component);

buffer_write(buffer, buffer_f32, component.light_dx);
buffer_write(buffer, buffer_f32, component.light_dy);
buffer_write(buffer, buffer_f32, component.light_dz);
buffer_write(buffer, buffer_u32, component.light_colour);