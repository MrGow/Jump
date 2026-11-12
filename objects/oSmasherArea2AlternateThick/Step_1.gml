/// oSmasherArea2AlternateThick — Begin Step
if (scr_game_frozen())
{
    head_previous_y = head_y;
    head_move_y = 0;
    descending = false;
    sync_smasher_collision();
    exit;
}
if (!enabled)
{
    head_previous_y = head_y;
    head_move_y = 0;
    active = false;
    descending = false;
    sync_smasher_collision();
    exit;
}
// ADVANCE ONE-SHOT AIR ANIMATIONS
if (air_top_frame >= 0 && spr_air_top != -1)
{
    air_top_frame += air_top_speed;
    if (air_top_frame >= sprite_get_number(spr_air_top)) air_top_frame = -1;
}
if (air_bottom_frame >= 0 && spr_air_bottom != -1)
{
    air_bottom_frame += air_bottom_speed;
    if (air_bottom_frame >= sprite_get_number(spr_air_bottom)) air_bottom_frame = -1;
}
head_previous_y = head_y;
previous_smash_state = smash_state;
var clock = -1;
if (use_shared_timing)
{
    if (!instance_exists(timing_controller)) timing_controller = find_timing_controller();
    if (instance_exists(timing_controller))
    {
        if (timing_seen_generation != timing_controller.reset_generation)
        {
            timing_seen_generation = timing_controller.reset_generation;
            cycle_initialized = false;
        }
        if (timing_controller.started)
            clock = timing_controller.clock_frames + round(timing_offset_frames) - round(timing_initial_delay);
    }
}
else
{
    local_clock++;
    clock = local_clock - round(timing_initial_delay);
}
if (clock < 0)
{
    head_offset = 0;
    head_y = head_raised_y;
    head_move_y = head_y - head_previous_y;
    smash_state = "raised";
    active = false;
    descending = false;
    cycle_initialized = false;
    sync_smasher_collision();
    exit;
}
var phase = clock mod cycle_frames;
if (phase < 0) phase += cycle_frames;
var warning_start = wait_frames;
var drop_start = warning_start + warning_frames;
var impact_start = drop_start + drop_frames;
var retract_start = impact_start + impact_hold_frames;
if (phase < warning_start)
{
    smash_state = "raised";
    head_offset = 0;
}
else if (phase < drop_start)
{
    smash_state = "warning";
    var t = (phase - warning_start + 1) / max(1, warning_frames);
    var eased = t * t * (3 - 2 * t);
    head_offset = round(-windup_distance * eased);
}
else if (phase < impact_start)
{
    smash_state = "descending";
    var t = (phase - drop_start + 1) / drop_frames;
    var eased = t * t;
    head_offset = round(-windup_distance + (smash_distance + windup_distance) * eased);
}
else if (phase < retract_start)
{
    smash_state = "impact";
    head_offset = smash_distance;
}
else
{
    smash_state = "retracting";
    var t = (phase - retract_start + 1) / retract_frames;
    var eased = t * t * (3 - 2 * t);
    head_offset = round(smash_distance * (1 - eased));
}
head_y = head_raised_y + head_offset;
head_move_y = head_y - head_previous_y;
descending = head_move_y > 0 && smash_state == "descending";
active = head_offset > 0;
if (cycle_initialized)
{
    if (smash_state == "descending" && previous_smash_state != "descending")
        smasher_play_sound(snd_smasher_down, smasher_down_gain);
    if (smash_state == "impact" && previous_smash_state != "impact")
        smasher_play_sound(snd_smasher_floor_hit, smasher_floor_hit_gain);
    if (smash_state == "retracting" && previous_smash_state != "retracting")
        smasher_play_sound(snd_smasher_lift, smasher_lift_gain);
}
// TRIGGER AIR FX ON STATE ENTRY
if (cycle_initialized && smash_state == "impact" && previous_smash_state != "impact"
    && air_bottom_enabled && spr_air_bottom != -1)
{
    air_bottom_frame = 0;
    air_bottom_anchor_x = center_x;
    air_bottom_anchor_y = head_y + bottom_h;
}
if (cycle_initialized && smash_state == "retracting" && previous_smash_state != "retracting"
    && air_top_enabled && spr_air_top != -1)
{
    air_top_frame = 0;
    air_top_anchor_x = center_x;
    air_top_anchor_y = head_y;
}
cycle_initialized = true;
sync_smasher_collision();
