/// @description void omu_mr_walking_on(UIThing);
/// @param UIThing

if (ds_list_size(argument0.root.route.steps)<255) {
    ds_list_add(argument0.root.route.steps, [MoveRouteActions.WALKING_ANIM_ON]);
}
