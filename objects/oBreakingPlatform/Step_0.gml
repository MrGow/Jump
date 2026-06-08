/// oBreakingPlatform — Step

if (!enabled) exit;

// Keep surface updated
surface_y = bbox_top;
dx = 0;
dy = 0;
solid_body = true;
solid_only_when_active = true;

// ----------------------------------------------------
// Detect player standing on platform
// ----------------------------------------------------
var p = instance_find(oPlayer, 0);

if (state == "idle" && p != noone)
{
    if (!(variable_instance_exists(p, "state") && p.state == "dead"))
    {
        var standing_on_this =
            variable_instance_exists(p, "standing_platform") &&
            p.standing_platform == id;

        if (standing_on_this)
        {
            state = "breaking";
            break_triggered = true;
            break_gone = false;

            image_index = 0;
            image_speed = break_anim_speed;
        }
    }
}

// ----------------------------------------------------
// State machine
// ----------------------------------------------------
if (state == "idle")
{
    active = true;
    break_gone = false;

    image_speed = 0;
    image_index = 0;
}
else if (state == "breaking")
{
    image_speed = break_anim_speed;

    // Platform stops supporting player before fully disappearing
    if (image_index >= break_frame)
    {
        active = false;
        break_gone = true;
    }

    // Fully disappeared
    if (image_index >= image_number - 1)
    {
        image_index = image_number - 1;
        image_speed = 0;

        active = false;
        break_gone = true;

        state = "gone";
        gone_timer = gone_hold_frames;
    }
}
else if (state == "gone")
{
    active = false;
    break_gone = true;

    image_speed = 0;
    image_index = image_number - 1;

    gone_timer--;

    if (gone_timer <= 0)
    {
        state = "rebuilding";

        image_speed = 0;
        image_index = image_number - 1;
    }
}
else if (state == "rebuilding")
{
    active = false;
    break_gone = true;

    // Manual reverse animation
    image_speed = 0;
    image_index -= rebuild_anim_speed;

    if (image_index <= 0)
    {
        image_index = 0;
        image_speed = 0;

        active = true;
        break_gone = false;
        break_triggered = false;

        state = "idle";
    }
}