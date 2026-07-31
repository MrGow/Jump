/// oSmasher — Create

event_inherited();

enabled = true;

base_x = x;
base_y = y;


// ====================================================
// CHILD / INSTANCE SPRITE OVERRIDES
// ====================================================

if (!variable_instance_exists(id, "smasher_sprite"))
{
    smasher_sprite =
        spriteHazardSmasherLength1Width1;
}

if (!variable_instance_exists(id, "mask_body_override"))
{
    mask_body_override =
        spriteSmasherMaskSolid;
}

if (!variable_instance_exists(id, "mask_full_override"))
{
    mask_full_override =
        spriteSmasherMask;
}

sprite_index =
    smasher_sprite;

image_speed = 0;
image_index = 0;

mask_body =
    mask_body_override;

mask_full =
    mask_full_override;

// Raised state initially uses only the permanent body.
mask_index =
    mask_body;


// ====================================================
// SHARED TIMING
// ====================================================

// True:
// derive the entire smasher cycle from an
// oHazardTimingController.
//
// False:
// use the original independent local timer.
if (!variable_instance_exists(id, "use_shared_timing"))
{
    use_shared_timing = true;
}

// Must match the controller's timing_group.
if (!variable_instance_exists(id, "timing_group"))
{
    timing_group = "default";
}

// Moves this smasher forward through the common cycle.
//
// Examples:
// 0   = normal
// 30  = thirty frames ahead
// 60  = sixty frames ahead
if (!variable_instance_exists(id, "timing_offset_frames"))
{
    timing_offset_frames = 0;
}

// Keeps this smasher raised for this many frames before
// joining the repeating clock pattern.
if (!variable_instance_exists(id, "timing_initial_delay"))
{
    timing_initial_delay = 0;
}

// Runtime controller reference.
timing_controller = noone;

// Reset/sound tracking.
timing_seen_generation = -1;
timing_initialized     = false;
timing_previous_phase  = 0;


// ====================================================
// GENERAL COLLISION STATE
// ====================================================

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}

solid_body = true;
solid_only_when_active = false;


// ----------------------------------------------------
// Horizontal trimming around the crushing plate
// ----------------------------------------------------

if (!variable_instance_exists(id, "crush_inset_x"))
{
    crush_inset_x = 5;
}


// ----------------------------------------------------
// Permits tiny gaps caused by player solid probes
// ----------------------------------------------------

if (!variable_instance_exists(id, "crush_contact_tolerance"))
{
    crush_contact_tolerance = 4;
}


// ----------------------------------------------------
// Plate must extend this far before dangerous
// ----------------------------------------------------

if (!variable_instance_exists(id, "crush_min_extension"))
{
    crush_min_extension = 3;
}


// ----------------------------------------------------
// Used to detect meaningful plate movement
// ----------------------------------------------------

if (!variable_instance_exists(id, "crush_move_threshold"))
{
    crush_move_threshold = 0.01;
}

if (!variable_instance_exists(id, "sink_px"))
{
    sink_px = 6;
}

if (!variable_instance_exists(id, "kill_only_when_falling"))
{
    kill_only_when_falling = false;
}

if (!variable_instance_exists(id, "crush_player_side_inset"))
{
    crush_player_side_inset = 6;
}


// ====================================================
// PLAYER DEATH PROFILE
// ====================================================

if (!variable_instance_exists(id, "smasher_death_type"))
{
    smasher_death_type = "crush";
}

if (!variable_instance_exists(id, "smasher_death_shake_strength"))
{
    smasher_death_shake_strength = -1;
}

if (!variable_instance_exists(id, "smasher_death_shake_frames"))
{
    smasher_death_shake_frames = -1;
}


// ====================================================
// FIND CURRENT PLATE BOTTOM
// ====================================================

find_plate_bottom = function()
{
    var scan_left =
        bbox_left;

    var scan_right =
        bbox_right;

    var scan_top =
        bbox_top;

    var scan_bottom =
        bbox_bottom;

    var width_now =
        max(
            1,
            scan_right - scan_left
        );

    var inset =
        max(
            2,
            floor(width_now * 0.10)
        );

    scan_left += inset;
    scan_right -= inset;

    if (scan_right < scan_left)
    {
        var mid =
            (
                bbox_left +
                bbox_right
            )
            *
            0.5;

        scan_left = mid;
        scan_right = mid;
    }

    var sample_count = 11;

    for (
        var yy = floor(scan_bottom);
        yy >= ceil(scan_top);
        yy--
    )
    {
        for (
            var i = 0;
            i < sample_count;
            i++
        )
        {
            var amount =
                i /
                max(
                    1,
                    sample_count - 1
                );

            var xx =
                lerp(
                    scan_left,
                    scan_right,
                    amount
                );

            if (
                collision_point(
                    xx,
                    yy,
                    id,
                    true,
                    false
                )
                != noone
            )
            {
                return yy;
            }
        }
    }

    return bbox_bottom;
};


// ====================================================
// FIND MATCHING TIMING CONTROLLER
// ====================================================

find_timing_controller = function()
{
    var wanted_group =
        string(timing_group);

    var count =
        instance_number(
            oHazardTimingController
        );

    for (
        var controller_index = 0;
        controller_index < count;
        controller_index++
    )
    {
        var controller =
            instance_find(
                oHazardTimingController,
                controller_index
            );

        if (!instance_exists(controller))
        {
            continue;
        }

        if (
            string(controller.timing_group) ==
            wanted_group
        )
        {
            return controller;
        }
    }

    return noone;
};


// ====================================================
// DETERMINE FRAME-0 RAISED PLATE POSITION
// ====================================================

var stored_mask =
    mask_index;

var stored_frame =
    image_index;

image_index = 0;
mask_index = mask_full;

plate_retracted_y =
    find_plate_bottom();

plate_y_previous =
    plate_retracted_y;

plate_y_current =
    plate_retracted_y;

plate_move_y = 0;
plate_extension = 0;

// 1 = descending
// -1 = retracting
// 0 = stationary or unknown
plate_direction = 0;

image_index =
    stored_frame;

mask_index =
    stored_mask;

active = false;


// ====================================================
// SMASHER MOVEMENT SFX
// ====================================================

if (!variable_instance_exists(id, "smasher_impact_frame"))
{
    smasher_impact_frame = 6;
}

if (!variable_instance_exists(id, "smasher_lift_frame"))
{
    smasher_lift_frame = 12;
}

if (!variable_instance_exists(id, "snd_smasher_down"))
{
    snd_smasher_down =
        asset_get_index("SmasherDown1");
}

if (!variable_instance_exists(id, "snd_smasher_lift"))
{
    snd_smasher_lift =
        asset_get_index("SmasherLift1");
}

if (!variable_instance_exists(id, "snd_smasher_floor_hit"))
{
    snd_smasher_floor_hit =
        asset_get_index("SmasherFloorHit1");
}

if (!variable_instance_exists(id, "smasher_down_gain"))
{
    smasher_down_gain = 0.55;
}

if (!variable_instance_exists(id, "smasher_lift_gain"))
{
    smasher_lift_gain = 0.35;
}

if (!variable_instance_exists(id, "smasher_floor_hit_gain"))
{
    smasher_floor_hit_gain = 0.80;
}

if (!variable_instance_exists(id, "smasher_sfx_inner_dist"))
{
    smasher_sfx_inner_dist = 250;
}

if (!variable_instance_exists(id, "smasher_sfx_outer_dist"))
{
    smasher_sfx_outer_dist = 400;
}

smasher_cycle_started       = false;
smasher_floor_sfx_played    = false;
smasher_lift_sfx_played     = false;
smasher_player_hit_sfx_lock = false;


// ====================================================
// ANIMATION
// ====================================================

if (!variable_instance_exists(id, "smasher_anim_speed"))
{
    smasher_anim_speed = 0.33;
}

if (!variable_instance_exists(id, "smasher_pause_s"))
{
    smasher_pause_s = 1.0;
}

smasher_pause_frames =
    round(
        room_speed *
        clamp(
            smasher_pause_s,
            0,
            7
        )
    );

// Number of room frames required for the animation to
// travel from frame zero to the final frame.
smasher_animation_frames =
    max(
        1,
        ceil(
            max(
                0,
                image_number - 1
            )
            /
            max(
                0.001,
                smasher_anim_speed
            )
        )
    );

// Total deterministic cycle length.
smasher_cycle_frames =
    max(
        1,
        smasher_pause_frames +
        smasher_animation_frames
    );

// Retained for local timing fallback.
smasher_pause_timer =
    smasher_pause_frames;