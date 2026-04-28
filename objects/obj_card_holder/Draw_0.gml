/// @description Insert description here
// You can write your code in this editor
draw_self();

//glow strength - hover or turn glow
var glow = max(hover_glow, turn_glow);

if(glow > 0.01){

    draw_set_alpha(0.4 * glow);
    draw_set_color(c_white);

    draw_rectangle(
        bbox_left - 3,
        bbox_top - 3,
        bbox_right + 3,
        bbox_bottom + 3,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}