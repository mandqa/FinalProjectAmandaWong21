/// @description Insert description here
// You can write your code in this editor
// destroy cards
for(var i = 0; i < ds_list_size(player_hand); i++){
    instance_destroy(player_hand[| i]);
}
for(var i = 0; i < ds_list_size(dealer_hand); i++){
    instance_destroy(dealer_hand[| i]);
}

ds_list_clear(player_hand);
ds_list_clear(dealer_hand);

// reset values
player_total = 0;
dealer_total = 0;

player_stayed = false;
dealer_stayed = false;

turn = "player";
round_over = false;

// reset dealing
deal_step = 0;
deal_timer = 0;

// reset triumph system
triumph_step = 0;
triumph_timer = 0;
wait_timer = 0;

//restart game->loops
round_state = ROUND_STATE.TRIUMPH;