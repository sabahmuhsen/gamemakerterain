/// @param UIRProgressBar

var bar = argument0;

Stuff.terrain.paint_strength = normalize_correct(bar.value, Stuff.terrain.paint_strength_min, Stuff.terrain.paint_strength_max, 0, 1);
bar.root.element_paint_strength.text = "Paint strength: " + string(Stuff.terrain.paint_strength);