/// oIntraTeleportController — Step

var p = instance_find(oPlayer, 0);
if (p == noone)
{
    global.intra_teleport_active = false;
    instance_destroy();
    exit;
}

// Freeze player during fake transition
p.hsp = 0;
p.vsp = 0;

if (variable_instance_exists(p, "jump_charging"))     p.jump_charging = false;
if (variable_instance_exists(p, "jump_charge"))       p.jump_charge = 0;
if (variable_instance_exists(p, "jump_charge_level")) p.jump_charge_level = 0;
if (variable_instance_exists(p, "bounce_pending"))    p.bounce_pending = false;
if (variable_instance_exists(p, "standing_platform")) p.standing_platform = noone;

if (state == "fade_out")
{
    fade_alpha += fade_speed_out;

    if (fade_alpha >= 1)
    {
        fade_alpha = 1;

        var d = find_destination(target_id);

        if (d != noone)
        {
            p.x = d.x + d.spawn_xoff;
            p.y = d.y + d.spawn_yoff;

            p.hsp = 0;
            p.vsp = 0;

            if (variable_instance_exists(d, "facing") && d.facing != 0)
            {
                p.facing = d.facing;
                p.image_xscale = d.facing;
            }

            if (variable_instance_exists(p, "state")) p.state = "idle";

            var z = find_zone_at(p.x, p.y);
            snap_camera_to_zone(z, p.x, p.y);
        }

        state = "hold";
    }
}
else if (state == "hold")
{
    hold_frames--;

    if (hold_frames <= 0)
    {
        state = "fade_in";
    }
}
else if (state == "fade_in")
{
    fade_alpha -= fade_speed_in;

    if (fade_alpha <= 0)
    {
        fade_alpha = 0;
        global.intra_teleport_active = false;
        instance_destroy();
    }
}