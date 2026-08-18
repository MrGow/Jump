/// oRoomTeleportController — Step

// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "entry_facing"))
{
    entry_facing = 1;
}

if (!variable_global_exists("room_teleport_entry_facing"))
{
    global.room_teleport_entry_facing =
        sign(entry_facing);

    if (global.room_teleport_entry_facing == 0)
    {
        global.room_teleport_entry_facing = 1;
    }
}


// ====================================================
// CONFIGURE TRANSITION TIMING
//
// Create runs before the trigger assigns area_name and
// show_area_name, so timing is selected on the first
// Step after those values have been received.
// ====================================================

if (!variable_instance_exists(id, "timing_configured"))
{
    timing_configured = false;
}

if (!timing_configured)
{
    timing_configured = true;

    var use_area_title =
        show_area_name &&
        area_name != "";


    // ------------------------------------------------
    // LONG AREA-TITLE TRANSITION
    // ------------------------------------------------

    if (use_area_title)
    {
        fade_speed_out =
            title_fade_speed_out;

        fade_speed_in =
            title_fade_speed_out_overlay;

        black_hold_frames =
            title_black_hold_frames;

        title_fade_in_frames =
            title_fade_in_frames_setting;

        title_hold_frames =
            title_hold_frames_setting;

        hold_frames =
            black_hold_frames +
            title_fade_in_frames +
            title_hold_frames;
    }


    // ------------------------------------------------
    // FAST SEAMLESS ROOM TRANSITION
    //
    // Matches the normal oCamera zone transition.
    // ------------------------------------------------

    else
    {
        fade_speed_out =
            fast_fade_speed_out;

        fade_speed_in =
            fast_fade_speed_in;

        black_hold_frames =
            fast_hold_frames;

        title_fade_in_frames =
            0;

        title_hold_frames =
            0;

        hold_frames =
            fast_hold_frames;

        title_timer = 0;
        title_alpha = 0;
        title_sound_played = false;
    }
}


// ====================================================
// FADE OUT
// ====================================================

if (state == "fade_out")
{
    var p =
        instance_find(
            oPlayer,
            0
        );

    if (p != noone)
    {
        if (
            variable_instance_exists(
                p,
                "hsp"
            )
        )
        {
            p.hsp = 0;
        }

        if (
            variable_instance_exists(
                p,
                "vsp"
            )
        )
        {
            p.vsp = 0;
        }

        if (
            variable_instance_exists(
                p,
                "jump_charging"
            )
        )
        {
            p.jump_charging = false;
        }

        if (
            variable_instance_exists(
                p,
                "jump_charge"
            )
        )
        {
            p.jump_charge = 0;
        }

        if (
            variable_instance_exists(
                p,
                "jump_charge_level"
            )
        )
        {
            p.jump_charge_level = 0;
        }
    }


    fade_alpha +=
        fade_speed_out;

    if (fade_alpha >= 1)
    {
        fade_alpha = 1;

        global.room_teleport_spawn_id =
            string(target_spawn);

        if (
            target_room != noone &&
            target_room != -1
        )
        {
            room_goto(
                target_room
            );

            state =
                "room_changed";
        }
        else
        {
            show_debug_message(
                "ROOM TELEPORT FAILED: target_room invalid"
            );

            global.room_teleport_active =
                false;

            global.room_teleport_spawn_id =
                "";

            global.room_teleport_entry_facing =
                0;

            instance_destroy();
        }
    }
}


// ====================================================
// ROOM CHANGED
// ====================================================

else if (state == "room_changed")
{
    // Give the destination room one Step to create its
    // player, spawn destinations, triggers and camera.
    state =
        "place_player";
}


// ====================================================
// PLACE PLAYER
// ====================================================

else if (state == "place_player")
{
    var p =
        instance_find(
            oPlayer,
            0
        );

    if (p == noone)
    {
        exit;
    }


    // ------------------------------------------------
    // Find requested destination
    // ------------------------------------------------

    var d = noone;

    var destination_count =
        instance_number(
            oRoomSpawnDest
        );

    for (
        var destination_index = 0;
        destination_index < destination_count;
        destination_index++
    )
    {
        var destination_candidate =
            instance_find(
                oRoomSpawnDest,
                destination_index
            );

        if (
            instance_exists(
                destination_candidate
            ) &&
            string(
                destination_candidate.spawn_id
            ) ==
            string(
                global.room_teleport_spawn_id
            )
        )
        {
            d =
                destination_candidate;

            break;
        }
    }


    // ------------------------------------------------
    // Place player
    // ------------------------------------------------

    if (instance_exists(d))
    {
        p.x = d.x;
        p.y = d.y;


        // =============================================
        // RESET MOVEMENT
        // =============================================

        if (
            variable_instance_exists(
                p,
                "hsp"
            )
        )
        {
            p.hsp = 0;
        }

        if (
            variable_instance_exists(
                p,
                "vsp"
            )
        )
        {
            p.vsp = 0;
        }

        if (
            variable_instance_exists(
                p,
                "state"
            )
        )
        {
            p.state =
                "idle";
        }

        if (
            variable_instance_exists(
                p,
                "standing_platform"
            )
        )
        {
            p.standing_platform =
                noone;
        }

        if (
            variable_instance_exists(
                p,
                "standing_platform_xoff"
            )
        )
        {
            p.standing_platform_xoff =
                0;
        }


        // =============================================
        // RESET JUMP CHARGE
        // =============================================

        if (
            variable_instance_exists(
                p,
                "jump_charging"
            )
        )
        {
            p.jump_charging =
                false;
        }

        if (
            variable_instance_exists(
                p,
                "jump_charge"
            )
        )
        {
            p.jump_charge =
                0;
        }

        if (
            variable_instance_exists(
                p,
                "jump_charge_level"
            )
        )
        {
            p.jump_charge_level =
                0;
        }

        if (
            variable_instance_exists(
                p,
                "charge_grace"
            )
        )
        {
            p.charge_grace =
                0;
        }

        if (
            variable_instance_exists(
                p,
                "support_grace"
            )
        )
        {
            p.support_grace =
                0;
        }

        if (
            variable_instance_exists(
                p,
                "charge_start_lock"
            )
        )
        {
            p.charge_start_lock =
                0;
        }

        if (
            variable_instance_exists(
                p,
                "prev_jump_h"
            )
        )
        {
            p.prev_jump_h =
                true;
        }


        // =============================================
        // DESTINATION FACING
        //
        // Destination facing:
        //  0 = preserve captured visual direction
        //  1 = force right
        // -1 = force left
        // =============================================

        var arrival_facing;


        // Forced direction from destination.
        if (d.facing != 0)
        {
            arrival_facing =
                sign(d.facing);
        }


        // Preserve the globally captured visual
        // direction from the original room.
        else if (
            variable_global_exists(
                "room_teleport_entry_facing"
            )
        )
        {
            arrival_facing =
                sign(
                    global.room_teleport_entry_facing
                );
        }


        // Controller-local fallback.
        else
        {
            arrival_facing =
                sign(entry_facing);
        }

        if (arrival_facing == 0)
        {
            arrival_facing = 1;
        }


        // Apply immediately.
        p.facing =
            arrival_facing;

        p.image_xscale =
            arrival_facing;


        // Keep this direction until horizontal input
        // has returned to neutral after arrival.
        p.teleport_facing_value =
            arrival_facing;

        p.teleport_facing_locked =
            true;


        // =============================================
        // DISARM OVERLAPPING ARRIVAL TRIGGERS
        //
        // Prevent immediate travel back to the room the
        // player just left.
        // =============================================

        var trigger_count =
            instance_number(
                oRoomTeleportTrigger
            );

        for (
            var trigger_index = 0;
            trigger_index < trigger_count;
            trigger_index++
        )
        {
            var arrival_trigger =
                instance_find(
                    oRoomTeleportTrigger,
                    trigger_index
                );

            if (!instance_exists(arrival_trigger))
            {
                continue;
            }

            var overlaps_arrival_trigger =
                p.bbox_right >
                    arrival_trigger.bbox_left &&
                p.bbox_left <
                    arrival_trigger.bbox_right &&
                p.bbox_bottom >
                    arrival_trigger.bbox_top &&
                p.bbox_top <
                    arrival_trigger.bbox_bottom;

            if (overlaps_arrival_trigger)
            {
                arrival_trigger.armed =
                    false;
            }
        }


        // =============================================
        // RESET CAMERA INTO DESTINATION ZONE
        // =============================================

        if (instance_exists(oCamera))
        {
            with (oCamera)
            {
                active_zone =
                    noone;

                pending_zone =
                    noone;

                fade_state =
                    0;

                fade_alpha =
                    0;

                event_perform(
                    ev_other,
                    ev_room_start
                );
            }
        }
    }
    else
    {
        show_debug_message(
            "ROOM TELEPORT WARNING: spawn not found: "
            +
            string(
                global.room_teleport_spawn_id
            )
        );
    }

    state =
        "hold";
}


// ====================================================
// BLACK HOLD / AREA NAME
// ====================================================

else if (state == "hold")
{
    title_timer++;

    if (
        show_area_name &&
        area_name != ""
    )
    {
        var t =
            title_timer;

        if (t < black_hold_frames)
        {
            title_alpha = 0;
        }
        else if (
            t <
            black_hold_frames +
            title_fade_in_frames
        )
        {
            // -----------------------------------------
            // Play the title sound once when the title
            // begins appearing.
            // -----------------------------------------

            if (!title_sound_played)
            {
                title_sound_played =
                    true;

                var snd_area_name =
                    asset_get_index(
                        "AreaNameSound"
                    );

                if (snd_area_name != -1)
                {
                    scr_play_sfx(
                        snd_area_name,
                        1,
                        random_range(
                            0.99,
                            1.01
                        )
                    );
                }
            }

            title_alpha =
                (
                    t -
                    black_hold_frames
                )
                /
                max(
                    1,
                    title_fade_in_frames
                );
        }
        else
        {
            title_alpha = 1;
        }

        title_alpha =
            clamp(
                title_alpha,
                0,
                1
            );
    }
    else
    {
        title_alpha = 0;
    }

    hold_frames--;

    if (hold_frames <= 0)
    {
        if (
            show_area_name &&
            area_name != ""
        )
        {
            title_alpha = 1;
        }
        else
        {
            title_alpha = 0;
        }

        state =
            "fade_in";
    }
}


// ====================================================
// FADE BACK TO GAMEPLAY
// ====================================================

else if (state == "fade_in")
{
    fade_alpha -=
        fade_speed_in;

    if (fade_alpha <= 0)
    {
        fade_alpha = 0;

        global.room_teleport_active =
            false;

        global.room_teleport_spawn_id =
            "";

        global.room_teleport_entry_facing =
            0;

        instance_destroy();
    }
}