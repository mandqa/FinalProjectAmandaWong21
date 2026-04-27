/// @description Insert description here
// You can write your code in this editor

enum ROUND_STATE {
    TRIUMPH,
    WAIT_TRIUMPH,
    DEAL,
    PLAY,
    END
}


//first state
round_state = ROUND_STATE.TRIUMPH;

//lists
player_hand = ds_list_create();
dealer_hand = ds_list_create();
player_triumphs = ds_list_create();
dealer_triumphs = ds_list_create();

//scores 
player_total = 0;
dealer_total = 0;
max_score = 21;

//dealing animation 
deal_step = 0;
deal_timer = 0;

//turns
turn = "player";
player_stayed = false;
dealer_stayed = false;

round_over = false;

//turn delay system - prevents switching instantly
turn_delay = 0;
turn_waiting = false;
next_turn_target = "";

//visuals
player_first_card_done = false;
overkill_player = false;
overkill_dealer = false;
shake_intensity = 0;

//wait delay
wait_timer = 0;

//functions for trump cards
triumph_step = 0;
triumph_timer = 0;
//possible abilities
triumph_pool = ["return","remove","disservice","shield","exchange","refresh"];

triumph_used_this_turn = false;

player_triumph_count = 0;
dealer_triumph_count = 0;

//draw card
function draw_card(owner)
{
    var card = choose(
        obj_card_1,obj_card_2,obj_card_3,obj_card_4,obj_card_5,
        obj_card_6,obj_card_7,obj_card_8,obj_card_9,obj_card_10,obj_card_11
    );

	//spawns if offscreen to set up animation
    var c = instance_create_layer(room_width + 100, 0, "Instances", card);
	audio_play_sound(snd_cardflick, 2, false);
    c.image_angle = random_range(-4, 4);
    c.owner = owner;

    if(owner == "player")
    {
        var index = ds_list_size(player_hand);

		c.hand_index = index; // 🔥 LOCK POSITION

		c.target_x = 200 + index * 130;
		c.target_y = 700;

		ds_list_add(player_hand, c);

        player_total += c.value;

        //shows the popup value only for first card
        if(!player_first_card_done)
        {
            var popup = instance_create_layer(0,0,"Instances",obj_card_value_popup);
			popup.value = c.value;
            popup.follow = c;

            player_first_card_done = true;
        }
    }

    if(owner == "dealer")
    {
        var index = ds_list_size(dealer_hand);

		c.hand_index = index;

		c.target_x = 200 + index * 130;
		c.target_y = 30;

		ds_list_add(dealer_hand, c);;
        dealer_total += c.value;
    }
}


//gives trump cards - resets per round
function give_triumphs()
{
    ds_list_clear(player_triumphs);
    ds_list_clear(dealer_triumphs);

    triumph_step = 0;
    triumph_timer = 0;
	
	player_triumph_count = 0;
    dealer_triumph_count = 0;
}


//starts the deal
function start_deal()
{
    deal_step = 0;
    deal_timer = 0;
}


//turn delay - how long it takes for next turn to happen, dont want it to go fast
function start_turn_delay(next_turn){
    turn_waiting = true;
    turn_delay = 180;
    next_turn_target = next_turn;
}


//player turn
function player_turn(){
    turn = "player";
	triumph_used_this_turn = false;
	turn_waiting = false;
}


//dealer turn logic 
function dealer_turn(){

    turn = "dealer";
	triumph_used_this_turn = false;
	turn_waiting = false;

    var used_triumph = false;

    if(ds_list_size(dealer_triumphs) > 0)
    {
        if(irandom(1) == 1)
        {
            var index = irandom(ds_list_size(dealer_triumphs) - 1);

            use_triumph("dealer", index);
            used_triumph = true;
        }
    }

    //continues normal logic if no triumph used
    if(!used_triumph)
    {
		dealer_normal_action();
    }

	//if ability used - skip the normal logic
	if(used_triumph)
	{
		check_turn_flow();
	    return;
	}
}

//dealer solution if not used any special cards
function dealer_normal_action()
{
    if(dealer_total < 17){
        draw_card("dealer");
        dealer_stayed = false;

        show_turn_text("Give me another.");
        audio_play_sound(snd_another2, 3, false);
    } 
    else {
        dealer_stayed = true;

        show_turn_text("I'll keep this.");
        audio_play_sound(snd_keep2, 3, false);
    }

    //return control after an action made
    check_turn_flow();
}


//turn flow control
function check_turn_flow(){

    // if both stayed -> end
    if(player_stayed && dealer_stayed){
        end_round();
        return;
    }

    // switch turns instead of forcing actions
    if(turn == "player"){
        turn = "dealer";
        start_turn_delay("dealer");
        return;
    }

    if(turn == "dealer"){
        turn = "player";
        start_turn_delay("player");
        return;
    }
}


//ending of round
function end_round(){
	//show_turn_text("IAnd the winner...");
    round_over = true;

    // reveal dealer deck
    for(var i = 0; i < ds_list_size(dealer_hand); i++){
        dealer_hand[| i].face_down = false;
    }

    // reveal player deck
    for(var i = 0; i < ds_list_size(player_hand); i++){
        player_hand[| i].face_down = false;
    }

    alarm[0] = 180;

	//black gui in round destroyed
    with(obj_card_value_popup){
        instance_destroy();
    }

	//triumph cards in round destroyed
	with(obj_triumph_played){
	    instance_destroy();
	}
	//other functions 
    player_first_card_done = false;
    overkill_player = false;
    overkill_dealer = false;
	player_triumph_count = 0;
	dealer_triumph_count = 0;
    round_state = ROUND_STATE.END;
}


function use_triumph(side, index)
{
	if(turn_waiting) return;
    if(triumph_used_this_turn) return;

    var list;
    var my_hand;
    var opp_hand;

    if(side == "player" ){
        list = player_triumphs;
        my_hand = player_hand;
        opp_hand = dealer_hand;
		
    } else {
        list = dealer_triumphs;
        my_hand = dealer_hand;
        opp_hand = player_hand;
		
    }
	

    var t = list[| index];

	var obj_to_spawn = noone;

	switch(t)
	{
	    case "return": obj_to_spawn = obj_return_played; break;
	    case "remove": obj_to_spawn = obj_remove_played; break;
	    case "exchange": obj_to_spawn = obj_exchange_played; break;
	    case "disservice": obj_to_spawn = obj_disservice_played; break;
		case "refresh": obj_to_spawn = obj_refresh_played; break;
	}


	if(obj_to_spawn != noone){
	    var inst = instance_create_layer(0, 0, "Instances", obj_to_spawn);
		inst.side = side; 
		
		if(side == "player")
	    {
	        inst.triumph_index = instance_number(obj_triumph_played);
			player_triumph_count++;
	    }
	    else
	    {
	        inst.triumph_index = dealer_triumph_count;
			dealer_triumph_count++;
	    }
	}
    //remove card ability
    if(t == "remove")
    {
        if(ds_list_size(opp_hand) > 1)
        {
            var last = ds_list_size(opp_hand) - 1;
            var card = opp_hand[| last];

            if(side == "player"){
                dealer_total -= card.value;
            } else {
                player_total -= card.value;
            }

            instance_destroy(card);
            ds_list_delete(opp_hand, last);
            ds_list_delete(list, index);

            triumph_used_this_turn = true;
			check_turn_flow();
        }

    }

    //exchange card ability
    if(t == "exchange")
    {
        if(ds_list_size(my_hand) > 1 && ds_list_size(opp_hand) > 1)
        {
            var my_last = ds_list_size(my_hand) - 1;
            var opp_last = ds_list_size(opp_hand) - 1;

            var my_card = my_hand[| my_last];
            var opp_card = opp_hand[| opp_last];

            if(side == "player"){
                player_total -= my_card.value;
                dealer_total -= opp_card.value;

                player_total += opp_card.value;
                dealer_total += my_card.value;
            } else {
                dealer_total -= my_card.value;
                player_total -= opp_card.value;

                dealer_total += opp_card.value;
                player_total += my_card.value;
            }

            var tx = my_card.target_x;
            var ty = my_card.target_y;

            my_card.target_x = opp_card.target_x;
            my_card.target_y = opp_card.target_y;

            opp_card.target_x = tx;
            opp_card.target_y = ty;

			my_card.owner = (side == "player") ? "dealer" : "player";
			opp_card.owner = side;
			
            my_hand[| my_last] = opp_card;
            opp_hand[| opp_last] = my_card;

            ds_list_delete(list, index);

            triumph_used_this_turn = true;
			check_turn_flow();
        }

    }
	
	//disservice card ability
		if(t == "disservice")
		{
	    if(side == "player"){
	        draw_card("dealer");
	    } else {
	        draw_card("player");
	    }

	    ds_list_delete(list, index);
	    triumph_used_this_turn = true;
		check_turn_flow();
	}
	
	//return card ability
		if(t == "return")
		{
	    if(ds_list_size(my_hand) > 1)
	    {
	        var last = ds_list_size(my_hand) - 1;
	        var card = my_hand[| last];

	        // subtract value
	        if(side == "player"){
	            player_total -= card.value;
	        } else {
	            dealer_total -= card.value;
	        }

	        instance_destroy(card);
	        ds_list_delete(my_hand, last);

	        ds_list_delete(list, index);
	        triumph_used_this_turn = true;
			check_turn_flow();
	    }

	}
	
	//refresh ability card
		if(t == "refresh")
		{
	    // remove popup only if player (dealer doesn’t use it)
	    if(side == "player"){
	        with(obj_card_value_popup){
	            instance_destroy();
	        }
	        player_first_card_done = false;
	    }

	    // remove all cards in your hand
	    for(var i = ds_list_size(my_hand) - 1; i >= 0; i--)
	    {
	        var c = my_hand[| i];

	        if(side == "player"){
	            player_total -= c.value;
	        } else {
	            dealer_total -= c.value;
	        }

	        instance_destroy(c);
	        ds_list_delete(my_hand, i);
	    }

	    // draw first card
	    draw_card(side);

	    // enforce face-down rule for BOTH sides
	    if(side == "player"){
	        my_hand[|0].face_down = true;
	    }
	    else if(side == "dealer"){
	        my_hand[|0].face_down = true;
	    }

	    // draw second card
	    draw_card(side);

	    // remove triumph card
	    ds_list_delete(list, index);

	    triumph_used_this_turn = true;
		check_turn_flow();

	   
	}
		//shield card ability - doesnt work yet bc i need to add more cards jst a placeholder
}




