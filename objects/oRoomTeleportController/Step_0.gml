/// oRoomTeleportController — Step

if (state == "fade_out")
{
    var p = instance_find(oPlayer, 0);
    if (p != noone)
    {
        if (variable_instance_exists(p, "hsp")) p.hsp = 0;
        if (variable_instance_exists(p, "vsp")) p.vsp = 0;
        if (variable_instance_exists(p, "jump_charging")) p.jump_charging = false;
        if (variable_instance_exists(p, "jump_charge")) p.jump_charge = 0;
        if (variable_instance_exists(p, "jump_charge_level")) p.jump_charge_level = 0;
    }

    fade_alpha += fade_speed_out;

    if (fade_alpha >= 1)
    {
        fade_alpha = 1;

        global.room_teleport_spawn_id = target_spawn;

        if (target_room != noone)
        {
            room_goto(target_room);
            state = "room_changed";
        }
    }
}
else if (state == "room_changed")
{
    // Wait one step after room change
    state = "place_player";
}
else if (state == "place_player")
{
    var p = instance_find(oPlayer, 0);
    if (p == noone) exit;

    var d = noone;

    var n = instance_number(oRoomSpawnDest);
    for (var i = 0; i < n; i++)
    {
        var s = instance_find(oRoomSpawnDest, i);
        if (s != noone && s.spawn_id == global.room_teleport_spawn_id)
        {
            d = s;
            break;
        }
    }

    if (d != noone)
    {
        p.x = d.x;
        p.y = d.y;

        if (variable_instance_exists(p, "hsp")) p.hsp = 0;
        if (variable_instance_exists(p, "vsp")) p.vsp = 0;
        if (variable_instance_exists(p, "state")) p.state = "idle";

        if (d.facing != 0)
        {
            p.facing = d.facing;
            p.image_xscale = d.facing;
        }

        // Force camera to initialize around the new CamZone
        if (instance_exists(oCamera))
        {
            with (oCamera)
            {
                active_zone = noone;
                pending_zone = noone;
                fade_state = 0;
                fade_alpha = 0;
                event_perform(ev_other, ev_room_start);
            }
        }
    }

    state = "hold";
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

        global.room_teleport_active = false;
        global.room_teleport_spawn_id = "";

        instance_destroy();
    }
}