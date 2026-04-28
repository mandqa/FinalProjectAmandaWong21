/// @description Insert description here
// You can write your code in this editor
draw_set_font(fnt_crd);
if(!open) exit;
if(!instance_exists(obj_game)) exit;

draw_set_font(fnt_crd);

// when hover and click
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var hovered_desc = "";

for(var i = 0; i < ds_list_size(gui_cards); i++){

    var c = gui_cards[| i];

    if(instance_exists(c)){

        if(point_in_rectangle(mx, my, c.x-60, c.y-60, c.x+60, c.y+60)){

            hovered_desc = c.desc;

            draw_set_color(c_white);
			draw_set_alpha(0.5);
            var offset_x = 60;
			var offset_y = 60;

			draw_rectangle(
			    c.x-60 + offset_x,
			    c.y-60 + offset_y,
			    c.x+43 + offset_x,
			    c.y+43+ offset_y,
			    false
			);

            //when clicked
            if(mouse_check_button_pressed(mb_left)){
                with(obj_game){
				    use_triumph("player", i);
				}

                // rebuild after using
                build_gui_cards();
            }
        }
    }
}


//description text
if(hovered_desc != ""){
	draw_set_font(fnt_crds);
    draw_set_color(c_white);
    draw_text(x + 75, display_get_gui_height() - 270, hovered_desc);
}