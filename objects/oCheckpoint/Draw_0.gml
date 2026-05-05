/// oCheckpoint — Draw

var active_now =
    variable_global_exists("checkpoint_set") &&
    global.checkpoint_set &&
    variable_global_exists("checkpoint_room") &&
    variable_global_exists("checkpoint_id") &&
    global.checkpoint_room == room &&
    global.checkpoint_id == checkpoint_id;

if (active_now) {
    draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, c_lime, 1);
} else {
    draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, c_white, 1);
}