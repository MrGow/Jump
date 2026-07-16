/// oMillipede — Create

depth = -15000;

// Composite object. All body pieces are drawn manually.
sprite_index = -1;

enabled    = true;
debug_draw = false;


// ====================================================
// EDITOR-VARIABLE SAFETY
// ====================================================

if (!variable_instance_exists(id, "route_id"))
{
    route_id = 0;
}

// 0 = back and forth
// 1 = closed loop
// 2 = one-way spawned stream
if (!variable_instance_exists(id, "route_mode"))
{
    route_mode = 0;
}

if (!variable_instance_exists(id, "middle_count"))
{
    middle_count = 2;
}

if (!variable_instance_exists(id, "move_speed"))
{
    move_speed = 0.65;
}

// Distance between middle-piece centres.
if (!variable_instance_exists(id, "segment_spacing"))
{
    segment_spacing = 31;
}

// Distance from either head to its adjoining middle.
// This is intentionally separate from segment_spacing.
if (!variable_instance_exists(id, "head_spacing"))
{
    head_spacing = 38;
}

if (!variable_instance_exists(id, "start_reversed"))
{
    start_reversed = false;
}

if (!variable_instance_exists(id, "endpoint_wait_frames"))
{
    endpoint_wait_frames = 0;
}

if (!variable_instance_exists(id, "reset_on_death"))
{
    reset_on_death = true;
}


// ----------------------------------------------------
// Visual body tuning
// ----------------------------------------------------
if (!variable_instance_exists(id, "body_lift"))
{
    body_lift = 1;
}

if (!variable_instance_exists(id, "body_wave_amount"))
{
    body_wave_amount = 0.75;
}

if (!variable_instance_exists(id, "body_wave_speed"))
{
    body_wave_speed = 0.12;
}

if (!variable_instance_exists(id, "body_wave_spacing"))
{
    body_wave_spacing = 0.85;
}


// ====================================================
// RUNTIME SAFETY
// ====================================================

route_mode =
    clamp(
        round(route_mode),
        0,
        2
    );

middle_count =
    max(
        1,
        round(middle_count)
    );

move_speed =
    max(
        0,
        move_speed
    );

segment_spacing =
    max(
        1,
        segment_spacing
    );

head_spacing =
    max(
        1,
        head_spacing
    );

endpoint_wait_frames =
    max(
        0,
        round(endpoint_wait_frames)
    );


// ====================================================
// SPAWNER OWNERSHIP
// ====================================================

// noone means this was manually placed in the room.
spawner_owner = noone;


// ====================================================
// SPRITES
// ====================================================

spr_head_left =
    asset_get_index("spriteMillipedeLeft");

spr_middle =
    asset_get_index("spriteMillipedeMiddle");

spr_head_right =
    asset_get_index("spriteMillipedeRight");


// ====================================================
// ANIMATION
// ====================================================

anim_position = 0;
anim_speed    = 0.35;


// ====================================================
// COLLISION
// ====================================================

collision_scale = 0.76;


// ====================================================
// ROUTE DATA
// ====================================================

route_ready = false;

route_nodes = [];

route_x = [];
route_y = [];

// 0 = floor
// 1 = right wall
// 2 = ceiling
// 3 = left wall
route_surface_rotation = [];

route_cumulative = [];

route_count  = 0;
route_length = 0;


// ====================================================
// MOVEMENT STATE
// ====================================================

// Route distance occupied by the current leading head.
lead_distance = 0;

// 1  = increasing node order
// -1 = decreasing node order
travel_direction = 1;

wait_timer      = 0;
reverse_pending = false;


// ====================================================
// SEGMENT CONSTRUCTION
// ====================================================

total_segments =
    middle_count + 2;

// Distance of each physical piece from the left head.
segment_chain_distance = [];

body_span = 0;

segment_x     = [];
segment_y     = [];
segment_angle = [];


// ====================================================
// HEAD TRAIL
//
// Oldest sample is index 0.
// Newest leading-head sample is at the final index.
// ====================================================

trail_x     = [];
trail_y     = [];
trail_angle = [];

trail_sample_spacing = 1.5;
trail_max_extra      = 48;


// ----------------------------------------------------
// Room-editor fallback position
// ----------------------------------------------------
placed_start_x = x;
placed_start_y = y;


// ====================================================
// SAMPLE AUTHORED ROUTE
//
// Returns:
//
// [0] X
// [1] Y
// [2] visual surface angle
// ====================================================

sample_route = function(_distance)
{
    if (!route_ready || route_count < 2)
    {
        return [
            placed_start_x,
            placed_start_y,
            0
        ];
    }

    var d = _distance;

    // Closed-loop route wraps.
    if (route_mode == 1)
    {
        d =
            (
                (d mod route_length) +
                route_length
            )
            mod route_length;
    }
    else
    {
        d =
            clamp(
                d,
                0,
                route_length
            );
    }

    var route_segment_count =
        route_mode == 1
        ? route_count
        : route_count - 1;

    for (
        var i = 0;
        i < route_segment_count;
        i++
    )
    {
        var next_index =
            (i + 1) mod route_count;

        var seg_start =
            route_cumulative[i];

        var seg_end =
            route_cumulative[i + 1];

        if (
            d <= seg_end ||
            i == route_segment_count - 1
        )
        {
            var sx = route_x[i];
            var sy = route_y[i];

            var ex = route_x[next_index];
            var ey = route_y[next_index];

            var seg_length =
                max(
                    0.0001,
                    seg_end - seg_start
                );

            var amount =
                clamp(
                    (d - seg_start) /
                    seg_length,
                    0,
                    1
                );

            var sample_x =
                lerp(
                    sx,
                    ex,
                    amount
                );

            var sample_y =
                lerp(
                    sy,
                    ey,
                    amount
                );

            var surface =
                route_surface_rotation[i];

            surface =
                (
                    (round(surface) mod 4) +
                    4
                )
                mod 4;

            return [
                sample_x,
                sample_y,
                surface * 90
            ];
        }
    }

    var final_surface =
        route_surface_rotation[
            route_count - 1
        ];

    final_surface =
        (
            (round(final_surface) mod 4) +
            4
        )
        mod 4;

    return [
        route_x[route_count - 1],
        route_y[route_count - 1],
        final_surface * 90
    ];
};


// ====================================================
// BUILD PHYSICAL SEGMENT SPACING
//
// Head-to-middle gaps use head_spacing.
// Middle-to-middle gaps use segment_spacing.
// ====================================================

build_segment_chain = function()
{
    total_segments =
        max(
            3,
            round(middle_count) + 2
        );

    segment_spacing =
        max(
            1,
            segment_spacing
        );

    head_spacing =
        max(
            1,
            head_spacing
        );

    segment_chain_distance =
        array_create(
            total_segments,
            0
        );

    var running_distance = 0;

    segment_chain_distance[0] = 0;

    for (
        var i = 1;
        i < total_segments;
        i++
    )
    {
        var gap;

        // Left head to first middle
        if (i == 1)
        {
            gap = head_spacing;
        }
        // Final middle to right head
        else if (i == total_segments - 1)
        {
            gap = head_spacing;
        }
        // Middle to middle
        else
        {
            gap = segment_spacing;
        }

        running_distance += gap;

        segment_chain_distance[i] =
            running_distance;
    }

    body_span =
        running_distance;

    segment_x =
        array_create(
            total_segments,
            placed_start_x
        );

    segment_y =
        array_create(
            total_segments,
            placed_start_y
        );

    segment_angle =
        array_create(
            total_segments,
            0
        );
};


// ====================================================
// REBUILD HEAD TRAIL
//
// Creates enough history behind the current leader for
// every body segment to appear immediately.
// ====================================================

rebuild_trail = function()
{
    trail_x     = [];
    trail_y     = [];
    trail_angle = [];

    var trail_required =
        body_span +
        trail_max_extra;

    var sample_step =
        max(
            1,
            trail_sample_spacing
        );

    var sample_count =
        ceil(
            trail_required /
            sample_step
        );

    // Oldest sample first.
    for (
        var i = sample_count;
        i >= 0;
        i--
    )
    {
        var behind_distance =
            i *
            sample_step;

        var route_distance =
            lead_distance -
            (
                behind_distance *
                travel_direction
            );

        var point =
            sample_route(
                route_distance
            );

        array_push(
            trail_x,
            point[0]
        );

        array_push(
            trail_y,
            point[1]
        );

        array_push(
            trail_angle,
            point[2]
        );
    }
};


// ====================================================
// ADD CURRENT HEAD POSITION TO TRAIL
// ====================================================

add_head_to_trail = function()
{
    var head_point =
        sample_route(
            lead_distance
        );

    var count =
        array_length(
            trail_x
        );

    if (count <= 0)
    {
        array_push(
            trail_x,
            head_point[0]
        );

        array_push(
            trail_y,
            head_point[1]
        );

        array_push(
            trail_angle,
            head_point[2]
        );

        return;
    }

    var last =
        count - 1;

    var moved =
        point_distance(
            trail_x[last],
            trail_y[last],
            head_point[0],
            head_point[1]
        );

    if (moved >= trail_sample_spacing)
    {
        array_push(
            trail_x,
            head_point[0]
        );

        array_push(
            trail_y,
            head_point[1]
        );

        array_push(
            trail_angle,
            head_point[2]
        );
    }
    else
    {
        // Keep the newest sample exactly on the head.
        trail_x[last] =
            head_point[0];

        trail_y[last] =
            head_point[1];

        trail_angle[last] =
            head_point[2];
    }

    // ------------------------------------------------
    // Trim history once it is safely longer than the
    // complete body.
    // ------------------------------------------------
    var required_length =
        body_span +
        trail_max_extra;

    while (array_length(trail_x) > 2)
    {
        var accumulated = 0;

        for (
            var i = array_length(trail_x) - 1;
            i > 0;
            i--
        )
        {
            accumulated +=
                point_distance(
                    trail_x[i],
                    trail_y[i],
                    trail_x[i - 1],
                    trail_y[i - 1]
                );

            if (accumulated >= required_length)
            {
                break;
            }
        }

        if (accumulated <= required_length)
        {
            break;
        }

        array_delete(
            trail_x,
            0,
            1
        );

        array_delete(
            trail_y,
            0,
            1
        );

        array_delete(
            trail_angle,
            0,
            1
        );
    }
};


// ====================================================
// SAMPLE THE HEAD TRAIL
//
// Returns:
//
// [0] X
// [1] Y
// [2] surface angle
// ====================================================

sample_trail = function(_behind_distance)
{
    var count =
        array_length(
            trail_x
        );

    if (count <= 0)
    {
        return [
            placed_start_x,
            placed_start_y,
            0
        ];
    }

    if (
        count == 1 ||
        _behind_distance <= 0
    )
    {
        var newest =
            count - 1;

        return [
            trail_x[newest],
            trail_y[newest],
            trail_angle[newest]
        ];
    }

    var remaining =
        _behind_distance;

    for (
        var i = count - 1;
        i > 0;
        i--
    )
    {
        var x1 =
            trail_x[i];

        var y1 =
            trail_y[i];

        var x0 =
            trail_x[i - 1];

        var y0 =
            trail_y[i - 1];

        var piece_distance =
            point_distance(
                x1,
                y1,
                x0,
                y0
            );

        if (piece_distance <= 0.0001)
        {
            continue;
        }

        if (remaining <= piece_distance)
        {
            var amount =
                remaining /
                piece_distance;

            var sample_x =
                lerp(
                    x1,
                    x0,
                    amount
                );

            var sample_y =
                lerp(
                    y1,
                    y0,
                    amount
                );

            var sample_angle =
                amount < 0.5
                ? trail_angle[i]
                : trail_angle[i - 1];

            return [
                sample_x,
                sample_y,
                sample_angle
            ];
        }

        remaining -=
            piece_distance;
    }

    return [
        trail_x[0],
        trail_y[0],
        trail_angle[0]
    ];
};


// ====================================================
// UPDATE PHYSICAL BODY SEGMENTS
// ====================================================

update_segments = function()
{
    if (!route_ready)
    {
        return;
    }

    var final_segment =
        total_segments - 1;

    for (
        var physical_index = 0;
        physical_index < total_segments;
        physical_index++
    )
    {
        var behind_leader;

        if (travel_direction > 0)
        {
            // Right head leads.
            behind_leader =
                body_span -
                segment_chain_distance[
                    physical_index
                ];
        }
        else
        {
            // Left head leads.
            behind_leader =
                segment_chain_distance[
                    physical_index
                ];
        }

        var sample =
            sample_trail(
                behind_leader
            );

        segment_x[physical_index] =
            sample[0];

        segment_y[physical_index] =
            sample[1];

        segment_angle[physical_index] =
            sample[2];
    }

    var leader_index =
        travel_direction > 0
        ? final_segment
        : 0;

    x =
        segment_x[
            leader_index
        ];

    y =
        segment_y[
            leader_index
        ];
};


// ====================================================
// BUILD ROUTE
// ====================================================

build_route = function()
{
    route_ready = false;

    route_nodes = [];

    route_x = [];
    route_y = [];

    route_surface_rotation = [];

    route_cumulative = [];

    route_count  = 0;
    route_length = 0;


    // ------------------------------------------------
    // Collect matching nodes
    // ------------------------------------------------
    var node_total =
        instance_number(
            oMillipedeRouteNode
        );

    for (
        var i = 0;
        i < node_total;
        i++
    )
    {
        var node =
            instance_find(
                oMillipedeRouteNode,
                i
            );

        if (node == noone)
        {
            continue;
        }

        if (node.route_id != route_id)
        {
            continue;
        }

        array_push(
            route_nodes,
            node
        );
    }

    route_count =
        array_length(
            route_nodes
        );

    if (route_count < 2)
    {
        show_debug_message(
            "MILLIPEDE ROUTE ERROR: route_id " +
            string(route_id) +
            " requires at least two nodes."
        );

        return false;
    }


    // ------------------------------------------------
    // Sort by node_order
    // ------------------------------------------------
    for (
        var a = 0;
        a < route_count - 1;
        a++
    )
    {
        var smallest = a;

        for (
            var b = a + 1;
            b < route_count;
            b++
        )
        {
            if (
                route_nodes[b].node_order <
                route_nodes[smallest].node_order
            )
            {
                smallest = b;
            }
        }

        if (smallest != a)
        {
            var temporary =
                route_nodes[a];

            route_nodes[a] =
                route_nodes[smallest];

            route_nodes[smallest] =
                temporary;
        }
    }


    // ------------------------------------------------
    // Cache node data
    // ------------------------------------------------
    for (
        var c = 0;
        c < route_count;
        c++
    )
    {
        var cached_node =
            route_nodes[c];

        array_push(
            route_x,
            cached_node.x
        );

        array_push(
            route_y,
            cached_node.y
        );

        var node_surface = 0;

        if (
            variable_instance_exists(
                cached_node,
                "surface_rotation"
            )
        )
        {
            node_surface =
                cached_node.surface_rotation;
        }

        node_surface =
            (
                (round(node_surface) mod 4) +
                4
            )
            mod 4;

        array_push(
            route_surface_rotation,
            node_surface
        );
    }


    // ------------------------------------------------
    // Build physical body spacing
    // ------------------------------------------------
    build_segment_chain();


    // ------------------------------------------------
    // Build cumulative route distances
    // ------------------------------------------------
    route_cumulative = [0];

    route_length = 0;

    for (
        var s = 0;
        s < route_count - 1;
        s++
    )
    {
        route_length +=
            point_distance(
                route_x[s],
                route_y[s],
                route_x[s + 1],
                route_y[s + 1]
            );

        array_push(
            route_cumulative,
            route_length
        );
    }


    // ------------------------------------------------
    // Closed loop returns from final node to node 0
    // ------------------------------------------------
    if (route_mode == 1)
    {
        route_length +=
            point_distance(
                route_x[route_count - 1],
                route_y[route_count - 1],
                route_x[0],
                route_y[0]
            );

        array_push(
            route_cumulative,
            route_length
        );
    }


    // ------------------------------------------------
    // Validate route
    // ------------------------------------------------
    if (route_length <= 0)
    {
        show_debug_message(
            "MILLIPEDE ROUTE ERROR: route_id " +
            string(route_id) +
            " has zero length."
        );

        return false;
    }

    if (
        route_mode != 1 &&
        route_length < body_span
    )
    {
        show_debug_message(
            "MILLIPEDE ROUTE WARNING: route_id " +
            string(route_id) +
            " is shorter than the body."
        );
    }


    // ------------------------------------------------
    // Initial movement direction
    // ------------------------------------------------
    travel_direction =
        start_reversed
        ? -1
        : 1;

    // Stream millipedes always move forwards.
    if (route_mode == 2)
    {
        travel_direction = 1;
    }


    // ------------------------------------------------
    // Initial leader position
    // ------------------------------------------------
    if (route_mode == 1)
    {
        lead_distance =
            start_reversed
            ? 0
            : body_span;
    }
    else if (travel_direction > 0)
    {
        lead_distance =
            min(
                route_length,
                body_span
            );
    }
    else
    {
        lead_distance =
            max(
                0,
                route_length -
                body_span
            );
    }


    wait_timer      = 0;
    reverse_pending = false;

    route_ready = true;

    rebuild_trail();
    update_segments();

    return true;
};


// ====================================================
// REVERSE PATROL
// ====================================================

reverse_patrol = function()
{
    if (travel_direction > 0)
    {
        travel_direction = -1;

        // Physical left head becomes the leader.
        lead_distance =
            max(
                0,
                route_length -
                body_span
            );
    }
    else
    {
        travel_direction = 1;

        // Physical right head becomes the leader.
        lead_distance =
            min(
                route_length,
                body_span
            );
    }

    wait_timer      = 0;
    reverse_pending = false;

    rebuild_trail();
    update_segments();
};


// ====================================================
// RESET MILLIPEDE
// ====================================================

reset_millipede = function()
{
    if (!reset_on_death)
    {
        return;
    }

    anim_position = 0;

    route_ready = false;

    build_route();
};