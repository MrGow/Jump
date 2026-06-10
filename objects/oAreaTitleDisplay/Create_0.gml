/// oAreaTitleDisplay — Create

area_name = "The Scrapyard";

if (variable_global_exists("pending_area_title")) {
    area_name = global.pending_area_title;
}

timer = 0;

type_speed = 5;
hold_time  = room_speed * 5.0;
fade_time  = room_speed * 0.6;

state = "typing";

shown_chars = 0;
alpha = 0;

show_debug_message("AREA TITLE DISPLAY CREATED: " + area_name);