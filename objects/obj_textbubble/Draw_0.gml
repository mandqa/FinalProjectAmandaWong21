/// @description Insert description here
// You can write your code in this editor
// saves this previous state (so no errors)
var _alpha = draw_get_alpha();
var _halign = draw_get_halign();
var _valign = draw_get_valign();
var _color = draw_get_color();

// apply bubble settings
draw_set_alpha(alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


draw_sprite_ext(spr_textbubble, 0, x, y, 0.5, 0.5, 0, c_white, alpha);

//draws text on sprite
draw_set_color(c_white); 
draw_text(x+200, y+190, text);

// restore previous state
draw_set_alpha(_alpha);
draw_set_halign(_halign);
draw_set_valign(_valign);
draw_set_color(_color);