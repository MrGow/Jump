/// oAreaTitleTrigger — Create

visible = false;

area_name = "The Scrapyard";
area_id   = "scrapyard";

trigger_dir = 1; // 1 = left-to-right, -1 = right-to-left, 0 = either

trigger_half_width  = 12;
trigger_half_height = 180;

triggered = false;
prev_player_x = noone;
spawn_grace = 10;

if (!variable_global_exists("area_title_seen")) {
    global.area_title_seen = ds_map_create();
}