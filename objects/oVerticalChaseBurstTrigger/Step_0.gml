/// oVerticalChaseBurstTrigger — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// ALREADY ACTIVATED
// ====================================================

if (activated)
{
    exit;
}


// ====================================================
// PLAYER
// ====================================================

var p = instance_find(oPlayer, 0);

if (p == noone)
{
    exit;
}

if (p.state == "dead")
{
    exit;
}


// ====================================================
// PLAYER OVERLAP
//
// Uses the actual collision bounds of the trigger.
// Works with resized rectangular sprites.
// Works while jumping, falling or gliding.
// ====================================================

var player_inside =
    p.bbox_right > bbox_left &&
    p.bbox_left < bbox_right &&
    p.bbox_bottom > bbox_top &&
    p.bbox_top < bbox_bottom;

if (!player_inside)
{
    exit;
}


// ====================================================
// ACTIVATE BURST
// ====================================================

var saw_obj =
    asset_get_index("oArea2ChasingSawsHorizontal");

if (saw_obj != -1)
{
    var saw = instance_find(saw_obj, 0);

    if (saw != noone)
    {
        saw.burst_target =
            saw.burst_offset +
            burst_distance;

        saw.burst_speed = burst_speed;
        saw.burst_active = true;
    }
}

activated = true;

show_debug_message("VERTICAL SAW BURST");