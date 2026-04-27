/// @description Insert description here
// You can write your code in this editor
switch(round_state)
{
		case ROUND_STATE.TRIUMPH:
		
	    triumph_timer++;

	    if(triumph_timer >= 60){
	        triumph_timer = 0;
			
		//show_debug_message()
	        switch(triumph_step){

	            //player special card 1 -rando pick
	            case 0:
	            {
	                var t = choose(
	                    triumph_pool[0],
	                    triumph_pool[1],
	                    triumph_pool[2],
	                    triumph_pool[3],
	                    triumph_pool[4],
						triumph_pool[5]
	                );

	                
					audio_play_sound(snd_tcard, 1, false);

					ds_list_add(player_triumphs, t);
					
					var index = ds_list_size(player_triumphs)-1;

					var c = instance_create_layer(display_get_width()+100, 450, "Instances", obj_triumph_card);

					c.owner_side = "player";
					c.triumph_index = index;
					c.triumph_type = t;

					c.target_x = 100 + index * 130;
					c.target_y = 470;
	            }
	            break;

	            //player special card 2
	            case 1:
	            {
	                var t = choose(
	                    triumph_pool[0],
	                    triumph_pool[1],
	                    triumph_pool[2],
	                    triumph_pool[3],
	                    triumph_pool[4],
						triumph_pool[5]
	                );
					
					audio_play_sound(snd_tcard, 1, false);

					ds_list_add(player_triumphs, t);
					
					var index = ds_list_size(player_triumphs)-1 ;

					var c = instance_create_layer(display_get_width()+100, 450, "Instances", obj_triumph_card);

					c.owner_side = "player";
					c.triumph_index = index;
					c.triumph_type = t;

					c.target_x = 100 + index * 130;
					c.target_y = 470;
	            }
	            break;

	            //dealer card 1
	            case 2:
	            {
	                var t = choose(
	                    triumph_pool[0],
	                    triumph_pool[1],
	                    triumph_pool[2],
	                    triumph_pool[3],
	                    triumph_pool[4],
						triumph_pool[5]
	                );

					audio_play_sound(snd_tcard, 1, false);

	                var index = dealer_triumph_count;
					dealer_triumph_count++;

					ds_list_add(dealer_triumphs, t);

					var c = instance_create_layer(display_get_width()+100, 250, "Instances", obj_triumph_card);

					c.owner_side = "dealer";
					c.triumph_index = index;
					c.triumph_type = t;

					c.target_x = 100 + index * 130;
					c.target_y = 200;
	            }
	            break;

	            //dealer card 2
	            case 3:
	            {
	                var t = choose(
	                    triumph_pool[0],
	                    triumph_pool[1],
	                    triumph_pool[2],
	                    triumph_pool[3],
	                    triumph_pool[4],
						triumph_pool[5]
	                );

					audio_play_sound(snd_tcard, 1, false);

	                var index = dealer_triumph_count;
					dealer_triumph_count++;

					ds_list_add(dealer_triumphs, t);

					var c = instance_create_layer(display_get_width()+100, 250, "Instances", obj_triumph_card);

					c.owner_side = "dealer";
					c.triumph_index = index;
					c.triumph_type = t;

					c.target_x = 100 + index * 130;
					c.target_y = 200;
					
	            }
	            break;

	            //finish phase
	            case 4:
	                round_state = ROUND_STATE.WAIT_TRIUMPH;
	            break;
	        }

	        triumph_step++;
	    }

	break;


    //trump wait time to deal
	case ROUND_STATE.WAIT_TRIUMPH:

	    if(instance_number(obj_triumph_card) == 0){

	        wait_timer++;

	        if(wait_timer > 30){
	            start_deal();
	            round_state = ROUND_STATE.DEAL;
	            wait_timer = 0;
	        }
	    }

	break;


    //dealing state
    case ROUND_STATE.DEAL:
        deal_timer++;

        if(deal_timer > 30){
            deal_timer = 0;

            switch(deal_step){

				//player first card faced down
                case 0:
                    draw_card("player");
                    player_hand[| ds_list_size(player_hand)-1].face_down = true;
                break;

				//dealer first card faced down
                case 1:
                    draw_card("dealer");
                    dealer_hand[| ds_list_size(dealer_hand)-1].face_down = true;
                break;

                case 2:
                    draw_card("player");
                break;

                case 3:
                    draw_card("dealer");
                    round_state = ROUND_STATE.PLAY;
                break;
            }

            deal_step++;
        }

    break;


    //play state - gameplay
	case ROUND_STATE.PLAY:
	
	if(!round_over && !turn_waiting){


	        if(turn == "player"){

	            //draw
	            if(keyboard_check_pressed(ord("Q"))){
	                draw_card("player");
					audio_play_sound(snd_cardflick, 2, false);
				
					show_turn_text("Give me another.");
					audio_play_sound(snd_another1, 3, false);
					
					//pass turn to dealer
					turn = "dealer";
					start_turn_delay("dealer");
	            }

	            //stay
	            if(keyboard_check_pressed(ord("E"))){
	                player_stayed = true;
					show_turn_text("I'll keep this.");
					audio_play_sound(snd_keep1, 3, false);
					
					//pass turn to dealer
					turn = "dealer";
					start_turn_delay("dealer");
	            }
	        }
			
	    }

    //overkill
    if(!round_over){
		
		//player bust
		if(player_total > 30 && !overkill_player){
			overkill_player = true;
            shake_intensity = 10;
            end_round();
			}

		//dealer bust
		if(dealer_total > 30 && !overkill_dealer){
			overkill_dealer = true;
            end_round();
            }
        }
    break;

    //end state
    case ROUND_STATE.END:
    break;
}


//turn delay
if(turn_waiting){

    turn_delay--;

    if(turn_delay <= 0){

        turn_waiting = false;
		
		//clears - prevents key triggers
		keyboard_clear(ord("Q"));
		keyboard_clear(ord("E")); 

		//trigger next turn logic
        if(next_turn_target == "player"){
            player_turn();
        }

        if(next_turn_target == "dealer"){
            dealer_turn();
        }
    }
}


//shake for overkill
if(shake_intensity > 0){
    shake_intensity *= 0.85;
} else {
    shake_intensity = 0;
}


//turn glow system
with(obj_card_holder){
    if(!variable_instance_exists(id, "owner")) exit;

	//highlights active players cards
    if(obj_game.turn == "player" && owner == "player"){
        turn_glow = lerp(turn_glow, 1, 0.2);
    }
    else if(obj_game.turn == "dealer" && owner == "dealer"){
        turn_glow = lerp(turn_glow, 1, 0.2);
    }
    else{
        turn_glow = lerp(turn_glow, 0, 0.2);
    }
}

//turn text to indicate stay or draw
function show_turn_text(msg)
{
    var b = instance_create_layer(room_width/2, room_height-120, "Instances", obj_textbubble);
    b.text = msg;
}


