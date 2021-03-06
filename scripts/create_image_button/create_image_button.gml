/// @param x
/// @param y
/// @param text
/// @param image
/// @param width
/// @param height
/// @param alignment
/// @param onmouseup
/// @param root
/// @param [anchor-horizontal]
/// @param [anchor-vertical]

with (instance_create_depth(argument[0], argument[1], 0, UIImageButton)) {
    text = argument[2];
    image = argument[3];
    width = argument[4];
    height = argument[5];
    
    surface = surface_create(width, height);

    alignment = argument[6];
    onmouseup = argument[7];
    root = argument[8];
    
    switch (argument_count) {
        case 11:
            switch (argument[10]) {
                case fa_top: break;
                case fa_middle: y = y - height / 2; break;
                case fa_bottom: y = y - height; break;
            }
        case 10:
            switch (argument[9]) {
                case fa_left: break;
                case fa_center: x = x - width / 2; break;
                case fa_right: x = x - width; break;
            }
    }
    
    return id;
}