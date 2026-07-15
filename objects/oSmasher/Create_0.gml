/// oSmasher — Create

event_inherited();

enabled = true;

base_x = x;
base_y = y;

// ----------------------------------------------------
// Child / instance sprite overrides
// ----------------------------------------------------
if (!variable_instance_exists(id, "smasher_sprite"))
{
    smasher_sprite = spriteHazardSmasherLength1Width1;
}

if (!variable_instance_exists(id, "mask_body_override"))
{
    mask_body_override = spriteSmasherMaskSolid;
}

if (!variable_instance_exists(id, "mask_full_override"))
{
    mask_full_override = spriteSmasherMask;
}

sprite_index = smasher_sprite;
image_speed  = 0;
image_index  = 0;

mask_body = mask_body_override;
mask_full = mask_full_override;

// Raised state initially uses only the permanent body.
mask_index = mask_body;

// ----------------------------------------------------
// General collision state
// ----------------------------------------------------
if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}

solid_body = true;
solid_only_when_active = false;

// Horizontal trimming around the crushing plate.
if (!variable_instance_exists(id, "crush_inset_x"))
{
    crush_inset_x = 5;
}

// Permits tiny gaps caused by the player's solid probes.
if (!variable_instance_exists(id, "crush_contact_tolerance"))
{
    crush_contact_tolerance = 4;
}

// Plate must extend this far before it is dangerous.
if (!variable_instance_exists(id, "crush_min_extension"))
{
    crush_min_extension = 3;
}

// Used to detect meaningful plate movement.
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

// ----------------------------------------------------
// Return the lowest occupied point in the current
// precise collision-mask frame.
//
// IMPORTANT:
// collision_point uses notme = false so the instance
// can detect its own collision mask.
// ----------------------------------------------------
find_plate_bottom = function()
{
    var scan_left   = bbox_left;
    var scan_right  = bbox_right;
    var scan_top    = bbox_top;
    var scan_bottom = bbox_bottom;

    // Avoid sampling only the extreme outside edges.
    var width_now = max(1, scan_right - scan_left);
    var inset = max(2, floor(width_now * 0.10));

    scan_left  += inset;
    scan_right -= inset;

    if (scan_right < scan_left)
    {
        var mid = (bbox_left + bbox_right) * 0.5;
        scan_left  = mid;
        scan_right = mid;
    }

    // More samples makes this reliable for wide variants.
    var sample_count = 11;

    // Search upward from the mask's maximum bounding-box bottom.
    for (var yy = floor(scan_bottom); yy >= ceil(scan_top); yy--)
    {
        for (var i = 0; i < sample_count; i++)
        {
            var amount = i / max(1, sample_count - 1);
            var xx = lerp(scan_left, scan_right, amount);

            // obj = id restricts the test to this smasher.
            // precise = true
            // notme = false, otherwise self would be ignored.
            if (collision_point(xx, yy, id, true, false) != noone)
            {
                return yy;
            }
        }
    }

    return bbox_bottom;
};

// ----------------------------------------------------
// Determine frame-0 raised plate position
// ----------------------------------------------------
var stored_mask  = mask_index;
var stored_frame = image_index;

image_index = 0;
mask_index  = mask_full;

plate_retracted_y = find_plate_bottom();

plate_y_previous = plate_retracted_y;
plate_y_current  = plate_retracted_y;
plate_move_y     = 0;
plate_extension  = 0;

// 1 = descending, -1 = retracting, 0 = stationary/unknown
plate_direction = 0;

image_index = stored_frame;
mask_index  = stored_mask;

active = false;

// ----------------------------------------------------
// SFX
// These frames control sound only, not player death.
// Children may override them.
// ----------------------------------------------------
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
    snd_smasher_down = asset_get_index("SmasherDown1");
}

if (!variable_instance_exists(id, "snd_smasher_lift"))
{
    snd_smasher_lift = asset_get_index("SmasherLift1");
}

if (!variable_instance_exists(id, "snd_smasher_floor_hit"))
{
    snd_smasher_floor_hit = asset_get_index("SmasherFloorHit1");
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

smasher_cycle_started         = false;
smasher_floor_sfx_played      = false;
smasher_lift_sfx_played       = false;
smasher_player_hit_sfx_lock   = false;

// ----------------------------------------------------
// Animation
// ----------------------------------------------------
if (!variable_instance_exists(id, "smasher_anim_speed"))
{
    smasher_anim_speed = 0.33;
}

if (!variable_instance_exists(id, "smasher_pause_s"))
{
    smasher_pause_s = 1.0;
}

smasher_pause_frames =
    round(room_speed * clamp(smasher_pause_s, 0, 7));

smasher_pause_timer = smasher_pause_frames;

if (!variable_instance_exists(id, "crush_player_side_inset"))
{
    crush_player_side_inset = 6;
}