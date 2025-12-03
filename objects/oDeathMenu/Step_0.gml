/// oDeathMenu — Step

// Fade in
if (alpha < 1) {
    alpha = clamp(alpha + fade_speed, 0, 1);
}

// Read input (you can replace these with oInput globals later)
var up    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var down  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
var left  = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
var right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));

// Use jump as confirm / "Climb"
var confirm = global.inp_jump_press;

// Navigate upgrades
var count = array_length(global.upgrades);
if (count <= 0) exit;

if (up)   selected_index = (selected_index - 1 + count) mod count;
if (down) selected_index = (selected_index + 1) mod count;

// Buy upgrade with left/right
if (left || right) {
    var u    = global.upgrades[selected_index];
    var cost = scr_upgrade_cost(selected_index);

    if (u.level < u.max_level && global.scrap_total >= cost) {
        global.scrap_total -= cost;
        u.level += 1;
        global.upgrades[selected_index] = u; // write back the struct
    }
}

// Start climb again
if (confirm) {
    if (instance_exists(oRunController)) {
        with (oRunController) {
            if (instance_exists(oPlayer)) {
                with (oPlayer) {
                    x = other.spawn_x;
                    y = other.spawn_y;
                    hsp = 0;
                    vsp = 0;
                    state = "alive";
                    hp    = max_hp;

                    sprite_index = spriteBotIdle;
                    image_index  = 0;
                    image_speed  = 0.2;
                }
            }
        }
    }

    global.game_phase = "playing";
    instance_destroy(); // close menu
}

