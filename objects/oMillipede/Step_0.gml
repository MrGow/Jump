/// oMillipede — Step

// ----------------------------------------------------
// Freeze movement, body animation and collision during
// pause, death delay and death menu.
// ----------------------------------------------------
if (scr_game_frozen())
{
    exit;
}

if (!enabled)
{
    exit;
}


// ----------------------------------------------------
// Build route when first created.
//
// Spawned stream millipedes receive their route settings
// immediately after creation, so lazy building ensures
// those values are used.
// ----------------------------------------------------
if (!route_ready)
{
    if (!build_route())
    {
        exit;
    }
}


// ====================================================
// ENDPOINT WAITING
// ====================================================

if (reverse_pending)
{
    if (wait_timer > 0)
    {
        wait_timer--;
    }
    else
    {
        reverse_patrol();
    }
}
else
{
    var speed_now =
        max(
            0,
            move_speed
        );


    // =================================================
    // BACK-AND-FORTH PATROL
    // =================================================
    if (route_mode == 0)
    {
        lead_distance +=
            speed_now *
            travel_direction;

        if (
            travel_direction > 0 &&
            lead_distance >= route_length
        )
        {
            lead_distance =
                route_length;

            add_head_to_trail();
            update_segments();

            reverse_pending = true;

            wait_timer =
                endpoint_wait_frames;
        }
        else if (
            travel_direction < 0 &&
            lead_distance <= 0
        )
        {
            lead_distance = 0;

            add_head_to_trail();
            update_segments();

            reverse_pending = true;

            wait_timer =
                endpoint_wait_frames;
        }
        else
        {
            add_head_to_trail();
            update_segments();
        }
    }


    // =================================================
    // CLOSED LOOP
    // =================================================
    else if (route_mode == 1)
    {
        lead_distance +=
            speed_now *
            travel_direction;

        lead_distance =
            (
                (lead_distance mod route_length) +
                route_length
            )
            mod route_length;

        add_head_to_trail();
        update_segments();
    }


    // =================================================
    // ONE-WAY SPAWNED STREAM
    // =================================================
    else if (route_mode == 2)
    {
        lead_distance +=
            speed_now;

        if (lead_distance >= route_length)
        {
            instance_destroy();
            exit;
        }

        add_head_to_trail();
        update_segments();
    }
}


// ----------------------------------------------------
// Mechanical body animation
// ----------------------------------------------------
anim_position +=
    anim_speed;


// ====================================================
// PLAYER COLLISION
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );

if (p == noone)
{
    exit;
}

if (
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    exit;
}


for (
    var physical_index = 0;
    physical_index < total_segments;
    physical_index++
)
{
    var spr = -1;

    if (physical_index == 0)
    {
        spr = spr_head_left;
    }
    else if (
        physical_index ==
        total_segments - 1
    )
    {
        spr = spr_head_right;
    }
    else
    {
        spr = spr_middle;
    }

    if (spr == -1)
    {
        continue;
    }

    var raw_w =
        sprite_get_width(spr) *
        collision_scale;

    var raw_h =
        sprite_get_height(spr) *
        collision_scale;

    var ang =
        segment_angle[
            physical_index
        ];

    var col_w =
        abs(dcos(ang)) * raw_w +
        abs(dsin(ang)) * raw_h;

    var col_h =
        abs(dsin(ang)) * raw_w +
        abs(dcos(ang)) * raw_h;

    var sx =
        segment_x[
            physical_index
        ];

    var sy =
        segment_y[
            physical_index
        ];

    var hit =
        p.bbox_right  > sx - col_w * 0.5 &&
        p.bbox_left   < sx + col_w * 0.5 &&
        p.bbox_bottom > sy - col_h * 0.5 &&
        p.bbox_top    < sy + col_h * 0.5;

    if (hit)
    {
        with (p)
        {
            scr_player_died();
        }

        exit;
    }
}