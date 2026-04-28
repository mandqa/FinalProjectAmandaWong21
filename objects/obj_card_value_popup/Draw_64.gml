/// @description Insert description here
// You can write your code in this editor
var gx = camera_get_view_x(view_camera[0]);
var gy = camera_get_view_y(view_camera[0]);

var draw_x = x - gx;
var draw_y = y - gy;

var th = string_height(string(value));

draw_set_font(fnt_crd);

// background
draw_set_color(c_black);
draw_set_alpha(0.7);

draw_rectangle(
    draw_x - 5,
    draw_y - 6,
    draw_x + 125,
    draw_y + th + 6,
    false
);

draw_set_alpha(1);
draw_set_color(c_white);

draw_text(draw_x + 50, draw_y + 5, string(value));

