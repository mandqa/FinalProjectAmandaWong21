/// @description Insert description here
// You can write your code in this editor
// slide animation or triumph cards
// smooth movement
x = lerp(x, target_x, move_speed);
y = lerp(y, target_y, move_speed);

// countdown for trump cards at beginning
life--;

if(life <= 0){
    instance_destroy();
}

