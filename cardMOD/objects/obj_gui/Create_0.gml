/// @description Insert description here
// You can write your code in this editor
open = false;

x = display_get_width();
target_x = x;


gui_cards = ds_list_create();

function build_gui_cards()
{
    // destroy old
    for(var i = 0; i < ds_list_size(gui_cards); i++){
        if(instance_exists(gui_cards[| i])){
            instance_destroy(gui_cards[| i]);
        }
    }
    ds_list_clear(gui_cards);

    if(!instance_exists(obj_game)) return;

    var list = obj_game.player_triumphs;

    // trump card limit
    var max_cards = 12;
    var count = min(ds_list_size(list), max_cards);

    for(var i = 0; i < count; i++){

        var t = list[| i];
        var obj;

        switch(t){
            case "return":     obj = obj_return_card; break;
            case "remove":     obj = obj_remove_card; break;
            case "disservice": obj = obj_disservice_card; break;
            case "shield":     obj = obj_shield_card; break;
            case "exchange":   obj = obj_exchange_card; break;
            case "refresh":    obj = obj_refresh_card; break;
        }

        var c = instance_create_layer(0, 0, "Instances", obj);

        ds_list_add(gui_cards, c);
    }
}