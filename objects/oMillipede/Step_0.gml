
/// oMillipede — Step

// ----------------------------------------------------
// Freeze during pause, death delay and death menu
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
// Build route lazily
//
// This allows a spawner to assign route values after
// creating the millipede.
// ----------------------------------------------------
if (!route_ready)
{
    if (!build_route())
    {
        exit;
    }
}


// ====================================================
// ENDPOINT WAIT / REVERSAL
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
    // BACK-AND-FORTH
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

            update_segments();

            reverse_pending = true;
            wait_timer      = endpoint_wait_frames;
        }
        else if (
            travel_direction < 0 &&
            lead_distance <= 0
        )
        {
            lead_distance = 0;

            update_segments();

            reverse_pending = true;
            wait_timer      = endpoint_wait_frames;
        }
        else
        {
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

        update_segments();
    }


    // =================================================
    // ONE-WAY STREAM
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

        update_segments();
    }
}


// ----------------------------------------------------
// Advance sprite animation
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

    var raw_width =
        sprite_get_width(spr) *
        collision_scale;

    var raw_height =
        sprite_get_height(spr) *
        collision_scale;

    var angle =
        segment_angle[
            physical_index
        ];

    var collision_width =
        abs(dcos(angle)) *
        raw_width +
        abs(dsin(angle)) *
        raw_height;

    var collision_height =
        abs(dsin(angle)) *
        raw_width +
        abs(dcos(angle)) *
        raw_height;

    var segment_cx =
        segment_x[
            physical_index
        ];

    var segment_cy =
        segment_y[
            physical_index
        ];

    var hit =
        p.bbox_right >
            segment_cx -
            collision_width * 0.5
        &&
        p.bbox_left <
            segment_cx +
            collision_width * 0.5
        &&
        p.bbox_bottom >
            segment_cy -
            collision_height * 0.5
        &&
        p.bbox_top <
            segment_cy +
            collision_height * 0.5;

    if (hit)
    {
        with (p)
        {
            scr_player_died();
        }

        exit;
    }
}