/// @description Insert description here
// You can write your code in this editor
switch(state)
{
    case "fade_in":
        alpha += 0.05;
        if(alpha >= 1){
            alpha = 1;
            state = "hold";
            timer = 60; // how long text stays
        }
    break;

    case "hold":
        timer--;
        if(timer <= 0){
            state = "fade_out";
        }
    break;

    case "fade_out":
        alpha -= 0.05;
        if(alpha <= 0){
            instance_destroy();
        }
    break;
}

