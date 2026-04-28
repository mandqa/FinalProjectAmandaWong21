/// @description Insert description here
// You can write your code in this editor
// toggle GUI
if(keyboard_check_pressed(vk_space)){
    open = !open;

    if(open){
        build_gui_cards();
    } else {
        // destroy cards when closing
        for(var i = 0; i < ds_list_size(gui_cards); i++){
            if(instance_exists(gui_cards[| i])){
                instance_destroy(gui_cards[| i]);
            }
        }
        ds_list_clear(gui_cards);
    }
}

// slide animation
if(open){
    target_x = display_get_width() - 600;
}else{
    target_x = display_get_width();
}

x = lerp(x, target_x, 0.2);

for (var i = 0; i < ds_list_size(gui_cards); i++) {

    var c = gui_cards[| i];

    if (instance_exists(c)) {

        var col = i mod 3;          // how the cards go row to column
        var row = i div 3;          

        c.x = x + 78 + col * 115;
        c.y = y + 120 + row * 120;
    }
}