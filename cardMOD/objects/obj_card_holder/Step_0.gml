/// @description Insert description here
// You can write your code in this editor
// movement
x = lerp(x, target_x, move_speed);
y = lerp(y, target_y, move_speed);

// flip sprite
if(face_down){
    image_index = 0;
}else{
    image_index = 1;
}


