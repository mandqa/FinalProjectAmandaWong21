/// @description Insert description here
// You can write your code in this editor
var shake_x = 0;
var shake_y = 0;

if(shake_intensity > 0){
    shake_x = random_range(-shake_intensity, shake_intensity);
    shake_y = random_range(-shake_intensity, shake_intensity);
}

//dealer card number gui
var dealer_visible = 0;
var dealer_hidden = false;

for (var i = 0; i < ds_list_size(dealer_hand); i++)
{
    var c = dealer_hand[| i];

    if (c.face_down){
		dealer_hidden = true;
	}
	else{
		dealer_visible += c.value;
	}
}

var dealer_text = "";

if(dealer_hidden){
    dealer_text = "? + " + string(dealer_visible);
}else{
    dealer_text = string(dealer_total);
}

draw_set_color(c_white);
draw_text(30 + shake_x, 100 + shake_y, dealer_text + " / " + string(max_score));



//player card number gui
var player_visible = 0;
var player_hidden = false;

for (var i = 0; i < ds_list_size(player_hand); i++)
{
    var c = player_hand[| i];

    if (c.face_down){
		player_hidden = true;
	}
    else{
		player_visible += c.value;
	}
}


//color changes on card amount
if (player_total > 30) // overkill
{
    draw_set_color(c_red);
    draw_text(50 + shake_x, 770 + shake_y, "OVERKILL");
}
else
{
    // color logic first
    if (player_total == 21) //21 changes color green
    {
        draw_set_color(c_green);
    }
    else if (player_total > 21) //21+ changes color red
    {
        draw_set_color(c_red);
    }
    else
    {
        draw_set_color(c_white); //white if under 21
    }

    //draws the text once
    draw_text(50 + shake_x, 770 + shake_y, string(player_total) + " / " + string(max_score));
}