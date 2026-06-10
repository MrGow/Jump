/// oAreaTitleTrigger — Step

if (triggered) exit;
if (!instance_exists(oPlayer)) exit;

if (!variable_global_exists("area_title_seen")) {
    global.area_title_seen = ds_map_create();
}

if (ds_map_exists(global.area_title_seen, area_id)) {
    triggered = true;
    exit;
}

var p = instance_find(oPlayer, 0);

if (spawn_grace > 0) {
    spawn_grace--;
    prev_player_x = p.x;
    exit;
}

if (prev_player_x == noone) {
    prev_player_x = p.x;
    exit;
}

var within_y =
    p.y > y - trigger_half_height &&
    p.y < y + trigger_half_height;

if (!within_y) {
    prev_player_x = p.x;
    exit;
}

var crossed = false;

if (trigger_dir == 1) {
    crossed = (prev_player_x < x && p.x >= x);
}
else if (trigger_dir == -1) {
    crossed = (prev_player_x > x && p.x <= x);
}
else {
    crossed =
        (prev_player_x < x && p.x >= x) ||
        (prev_player_x > x && p.x <= x);
}

var near_x = abs(p.x - x) <= trigger_half_width;

if (crossed && near_x)
{
    ds_map_set(global.area_title_seen, area_id, true);
    triggered = true;

    global.pending_area_title = area_name;

    if (instance_exists(oAreaTitleDisplay)) {
        with (oAreaTitleDisplay) instance_destroy();
    }

    instance_create_depth(0, 0, -100, oAreaTitleDisplay);

    show_debug_message("AREA TITLE FIRED: " + area_name);
}

prev_player_x = p.x;