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
        global.room_teleport_spawn_id = string(target_spawn);

        if (target_room != noone && target_room != -1)
        {
            room_goto(target_room);
            state = "room_changed";
        }
        else
        {
            show_debug_message("ROOM TELEPORT FAILED: target_room invalid");
            global.room_teleport_active = false;
            global.room_teleport_spawn_id = "";
            instance_destroy();
        }
    }
}
else if (state == "room_changed")
{
    state = "place_player";
}
else if (state == "place_player")
{
    var p = instance_find(oPlayer, 0);
    if (p == noone) exit;

    var d = noone;

    for (var i = 0; i < instance_number(oRoomSpawnDest); i++)
    {
        var s = instance_find(oRoomSpawnDest, i);

        if (s != noone && string(s.spawn_id) == string(global.room_teleport_spawn_id))
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
    else
    {
        show_debug_message("ROOM TELEPORT WARNING: spawn not found: " + string(global.room_teleport_spawn_id));
    }

    state = "hold";
}
else if (state == "hold")
{
    title_timer++;

    if (show_area_name && area_name != "")
    {
        var t = title_timer;

        if (t < black_hold_frames)
        {
            title_alpha = 0;
        }
        else if (t < black_hold_frames + title_fade_in_frames)
        {
            title_alpha = (t - black_hold_frames) / title_fade_in_frames;
        }
        else
        {
            // Important: stays fully cut out until the black fades away
            title_alpha = 1;
        }

        title_alpha = clamp(title_alpha, 0, 1);
    }

    hold_frames--;

    if (hold_frames <= 0)
    {
        // Do NOT set title_alpha = 0 here.
        // Keep the text cut-out active during fade_in.
        title_alpha = 1;
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