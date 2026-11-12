/// oSmasherArea2Alternate — End Step
// Descending head physically pushes the player, or crushes if blocked.
if (scr_game_frozen()) exit;
if (!enabled || !descending || head_move_y <= 0) exit;
var player = instance_find(oPlayer, 0);
if (!instance_exists(player)) exit;
if (variable_instance_exists(player, "state") && player.state == "dead") exit;
var head_left = bottom_x + crush_inset_x;
var head_right = bottom_x + bottom_w - crush_inset_x;
var old_head_bottom = head_previous_y + bottom_h;
var new_head_bottom = head_y + bottom_h;
if (player.bbox_right <= head_left || player.bbox_left >= head_right) exit;
var player_previous_top = player.bbox_top - (player.y - player.yprevious);
var player_current_top = player.bbox_top;
var approached_from_above = old_head_bottom <= player_previous_top + 2;
var crossed_player_top = new_head_bottom >= min(player_previous_top, player_current_top);
if (!approached_from_above || !crossed_player_top) exit;
var required_push = max(0, new_head_bottom + 1 - player.bbox_top);
if (required_push <= 0) exit;
var remaining = required_push;
var blocked = false;
while (remaining > 0)
{
    var step_amount = min(1, remaining);
    var next_y = player.y + step_amount;
    var tile_blocked = false;
    with (player)
    {
        tile_blocked = scr_player_meeting_solid(x, next_y);
    }
    var next_bottom = player.bbox_bottom + step_amount;
    var next_left = player.bbox_left + 3;
    var next_right = player.bbox_right - 3;
    var floor_blocked = false;
    var floor_list = ds_list_create();
    var floor_count = collision_rectangle_list(next_left, player.bbox_bottom, next_right, next_bottom + 1, oFloorSurface, false, true, floor_list, false);
    for (var i = 0; i < floor_count; i++)
    {
        var floor_inst = floor_list[| i];
        if (!instance_exists(floor_inst)) continue;
        if (floor_inst == collision_head) continue;
        if (variable_instance_exists(floor_inst, "enabled") && !floor_inst.enabled) continue;
        if (variable_instance_exists(floor_inst, "active") && !floor_inst.active) continue;
        var surface_top = floor_inst.bbox_top;
        if (variable_instance_exists(floor_inst, "surface_y")) surface_top = floor_inst.surface_y;
        if (surface_top >= player.bbox_bottom - 1 && surface_top <= next_bottom + 1)
        {
            floor_blocked = true;
            break;
        }
    }
    ds_list_destroy(floor_list);
    if (tile_blocked || floor_blocked)
    {
        blocked = true;
        break;
    }
    player.y += step_amount;
    remaining -= step_amount;
}
if (blocked)
{
    var lock_y = player.bbox_bottom + sink_px;
    var shake_strength_argument = smasher_death_shake_strength >= 0 ? smasher_death_shake_strength : undefined;
    var shake_frames_argument = smasher_death_shake_frames >= 0 ? smasher_death_shake_frames : undefined;
    var death_type = smasher_death_type;
    with (player)
    {
        scr_player_died(lock_y, false, shake_strength_argument, shake_frames_argument, death_type);
    }
    exit;
}
with (player)
{
    vsp = max(vsp, 12);
    smasher_punt_speed = 12;
    smasher_punt_frames = 8;
    smasher_punt_landing_lock = true;
    standing_platform = noone;
    standing_platform_xoff = 0;
    jump_charging = false;
    jump_charge = 0;
    jump_charge_level = 0;
    bounce_pending = false;
    bounce_timer = 0;
    if (state != "dead" && state != "glide") state = "glide";
}
